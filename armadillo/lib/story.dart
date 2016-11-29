// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'panel.dart';
import 'story_bar.dart';
import 'story_cluster_id.dart';

class StoryId<T> extends ValueKey<T> {
  StoryId(T value) : super(value);
}

typedef Widget OpacityBuilder(BuildContext context, double opacity);

/// The representation of a Story.  A Story's contents are display as a [Widget]
/// provided by [builder] while the size of a story in the [RecentList] is
/// determined by [lastInteraction] and [cumulativeInteractionDuration].
class Story {
  final StoryId id;
  final WidgetBuilder builder;
  final List<OpacityBuilder> icons;
  final OpacityBuilder avatar;
  final String title;
  final DateTime lastInteraction;
  final Duration cumulativeInteractionDuration;
  final Color themeColor;
  final bool inactive;
  final StoryClusterId clusterId;
  final GlobalKey<StoryBarState> storyBarKey;
  final GlobalKey storyBarPaddingKey;
  final GlobalKey clusterDraggableKey;
  final GlobalKey positionedKey;
  final GlobalKey containerKey;
  final GlobalKey tabSizerKey;
  final Panel panel;

  Story({
    this.id,
    this.builder,
    this.title: '',
    this.icons: const <OpacityBuilder>[],
    this.avatar,
    this.lastInteraction,
    this.cumulativeInteractionDuration,
    this.themeColor,
    this.inactive: false,
    StoryClusterId clusterId,
    GlobalKey<StoryBarState> storyBarKey,
    GlobalKey storyBarPaddingKey,
    GlobalKey clusterDraggableKey,
    GlobalKey positionedKey,
    GlobalKey containerKey,
    GlobalKey tabSizerKey,
    Panel panel,
  })
      : this.clusterId = clusterId ?? new StoryClusterId(),
        this.storyBarKey = storyBarKey ?? new GlobalKey<StoryBarState>(),
        this.storyBarPaddingKey = storyBarPaddingKey ?? new GlobalKey(),
        this.clusterDraggableKey = clusterDraggableKey ?? new GlobalKey(),
        this.positionedKey = positionedKey ?? new GlobalKey(),
        this.containerKey = containerKey ?? new GlobalKey(),
        this.tabSizerKey = tabSizerKey ?? new GlobalKey(),
        this.panel = panel ?? new Panel();

  Story copyWith({
    DateTime lastInteraction,
    Duration cumulativeInteractionDuration,
    bool inactive,
    Panel panel,
    GlobalKey clusterDraggableKey,
  }) =>
      new Story(
        id: this.id,
        builder: this.builder,
        lastInteraction: lastInteraction ?? this.lastInteraction,
        cumulativeInteractionDuration:
            cumulativeInteractionDuration ?? this.cumulativeInteractionDuration,
        themeColor: this.themeColor,
        icons: new List.from(this.icons),
        avatar: this.avatar,
        title: this.title,
        inactive: inactive ?? this.inactive,
        clusterId: this.clusterId,
        storyBarKey: this.storyBarKey,
        storyBarPaddingKey: this.storyBarPaddingKey,
        clusterDraggableKey: this.clusterDraggableKey,
        positionedKey: this.positionedKey,
        containerKey: this.containerKey,
        tabSizerKey: this.tabSizerKey,
        panel: panel ?? this.panel,
      );

  /// Returns true if the [Story] has no content and should just take up empty
  /// space.
  bool get isPlaceHolder => false;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) => (other is Story && other.id == id);

  @override
  String toString() => 'Story( id: $id, title: $title, panel: $panel )';

  static int storyListHashCode(List<Story> stories) =>
      hashList(stories.map((Story s) => s.id));
}