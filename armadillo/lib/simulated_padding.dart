// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:sysui_widgets/rk4_spring_simulation.dart';
import 'package:sysui_widgets/ticking_state.dart';

const RK4SpringDescription _kDefaultSimulationDesc =
    const RK4SpringDescription(tension: 750.0, friction: 50.0);

/// Animates a [Padding]'s [fractionalLeftPadding] and [fractionalRightPadding]
/// with a spring simulation.
class SimulatedPadding extends StatefulWidget {
  final RK4SpringDescription springDescription;
  final double fractionalLeftPadding;
  final double fractionalRightPadding;
  final double width;
  final Widget child;

  SimulatedPadding({
    Key key,
    this.fractionalLeftPadding,
    this.fractionalRightPadding,
    this.width,
    this.springDescription: _kDefaultSimulationDesc,
    this.child,
  })
      : super(key: key);

  @override
  SimulatedPaddingState createState() => new SimulatedPaddingState();
}

class SimulatedPaddingState extends TickingState<SimulatedPadding> {
  RK4SpringSimulation _leftSimulation;
  RK4SpringSimulation _rightSimulation;

  @override
  void initState() {
    super.initState();
    _leftSimulation = new RK4SpringSimulation(
      initValue: config.fractionalLeftPadding,
      desc: config.springDescription,
    );
    _rightSimulation = new RK4SpringSimulation(
      initValue: config.fractionalRightPadding,
      desc: config.springDescription,
    );
  }

  @override
  void didUpdateConfig(SimulatedPadding oldConfig) {
    super.didUpdateConfig(oldConfig);
    _leftSimulation.target = config.fractionalLeftPadding;
    _rightSimulation.target = config.fractionalRightPadding;
    startTicking();
  }

  @override
  Widget build(BuildContext context) => new Padding(
        padding: new EdgeInsets.only(
          left:
              config.width * _leftSimulation.value.clamp(0.0, double.INFINITY),
          right:
              config.width * _rightSimulation.value.clamp(0.0, double.INFINITY),
        ),
        child: config.child,
      );

  @override
  bool handleTick(double elapsedSeconds) {
    _leftSimulation.elapseTime(elapsedSeconds);
    _rightSimulation.elapseTime(elapsedSeconds);
    return !_leftSimulation.isDone || !_rightSimulation.isDone;
  }
}