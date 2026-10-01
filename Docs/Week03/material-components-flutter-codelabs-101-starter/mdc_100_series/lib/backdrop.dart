// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'model/product.dart';

// Class untuk mengatur kecepatan animasi fling
const double _kFlingVelocity = 2.0;

class Backdrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  const Backdrop({
    Key? key,
    required this.currentCategory,
    required this.frontLayer,
    required this.backLayer,
    required this.frontTitle,
    required this.backTitle,
  }) : super(key: key);

  @override
  State<Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(Backdrop old) {
    super.didUpdateWidget(old);

    if (widget.currentCategory != old.currentCategory) {
      _toggleBackdropRowAnimation();
    } else if (!_controller.isCompleted) {
      _controller.fling(velocity: _kFlingVelocity);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _backLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropRowAnimation() {
    _controller.fling(
        velocity: _backLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, layerTop, 0.0, layerTop - layerSize.height),
      end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);

    return Stack(
      children: <Widget>[
        ExcludeSemantics(
          excluding: _backLayerVisible,
          child: widget.backLayer,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            onTap: _toggleBackdropRowAnimation,
            child: widget.frontLayer,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      title: _BackdropTitle(
        listenable: _controller.view,
        onPress: _toggleBackdropRowAnimation,
        frontTitle: widget.frontTitle,
        backTitle: widget.backTitle,
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.search,
            semanticLabel: 'search',
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.tune,
            semanticLabel: 'filter',
          ),
          onPressed: () {},
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(builder: _buildStack),
    );
  }
}

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 40.0,
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _BackdropTitle extends AnimatedWidget {
  final void Function() onPress;
  final Widget frontTitle;
  final Widget backTitle;

  const _BackdropTitle({
    Key? key,
    required Listenable listenable,
    required this.onPress,
    required this.frontTitle,
    required this.backTitle,
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.titleLarge!,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(children: <Widget>[
        // 1. Ikon garis tiga (hanya muncul di homescreen dan menghilang saat di menu)
        SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          axisAlignment: -1.0,
          child: SizedBox(
            width: 48.0,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: onPress,
              icon: const Icon(Icons.menu),
            ),
          ),
        ),
        // 2. Logo diamond (selalu tampil di homescreen maupun di menu)
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 4.0),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onPress,
            icon: const ImageIcon(AssetImage('assets/diamond.png')),
          ),
        ),
        // 3. Transisi teks judul (SHRINE / MENU)
        Expanded(
          child: GestureDetector(
            onTap: onPress,
            child: Stack(
              children: <Widget>[
                Opacity(
                  opacity: CurvedAnimation(
                    parent: reverseAnimation(animation),
                    curve: const Interval(0.5, 1.0),
                  ).value,
                  child: FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(0.5, 0.0),
                    ).evaluate(animation),
                    child: backTitle,
                  ),
                ),
                Opacity(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.5, 1.0),
                  ).value,
                  child: FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: const Offset(-0.5, 0.0),
                      end: Offset.zero,
                    ).evaluate(animation),
                    child: frontTitle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Animation<double> reverseAnimation(Animation<double> animation) {
    return Tween<double>(begin: 1.0, end: 0.0).animate(animation);
  }
}