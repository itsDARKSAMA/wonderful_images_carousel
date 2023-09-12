import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A widget to show a carousel of images

class WonderfulImagesCarousel extends StatefulWidget {
  /// [images] is a list of images url
  final List images;

  /// [height] is the height of the carousel , default is 200
  final double? height;

  /// [width] is the width of the carousel , default is the width of the screen
  final double? width;

  /// [borderRadius] is the border radius of the carousel , default is 10
  final double? borderRadius;

  /// [backgroundColor] is the background color of the carousel , default is grey[300]
  final Color? backgroundColor;

  /// [indicatorColor] is the color of the indicator , default is the primary color of the app
  final Color? indicatorColor;

  /// [unselectedIndicatorColor] is the color of the unselected indicator , default is grey[300]
  final Color? unselectedIndicatorColor;

  /// [indicatorSize] is the size of the indicator , default is 15
  final double? indicatorSize;

  /// [unSelectedIndicatorSize] is the size of the unselected indicator , default is 10
  final double? unSelectedIndicatorSize;

  /// [indicatorSpacing] is the spacing between the indicators , default is 4
  final double? indicatorSpacing;

  /// [autoSlide] is a boolean to enable auto slide , default is true
  final bool? autoSlide;

  /// [autoSlideDuration] is the duration of the auto slide , default is 6 seconds
  final int? autoSlideDuration;

  /// [slideDuration] is the duration of the slide , default is 300 milliseconds
  final int? slideDuration;

  /// [slideCurve] is the curve of the slide , default is Curves.easeIn
  final Curve? slideCurve;

  /// [loadingIndicatorWidget] is the widget to show while loading the image from the network
  final Widget? loadingIndicatorWidget;

  /// [onErrorWidget] is the widget to show if there is an error while loading the image from the network , default is an error icon with a red color
  final Widget? onErrorWidget;

  /// [edgeMargin] is the margin of the container , default is 16
  final EdgeInsetsGeometry? edgeMargin;

  /// [indicatorTopPosition] is the top position of the indicator , default is nothing
  final double? indicatorTopPosition;

  /// [indicatorRightPosition] is the right position of the indicator , default is 25
  final double? indicatorRightPosition;

  /// [indicatorBottomPosition] is the bottom position of the indicator , default is 25
  final double? indicatorBottomPosition;

  /// [indicatorLeftPosition] is the left position of the indicator , default is nothing
  final double? indicatorLeftPosition;

  const WonderfulImagesCarousel(
      {super.key,
      required this.images,
      this.height,
      this.width,
      this.borderRadius,
      this.backgroundColor,
      this.indicatorColor,
      this.unselectedIndicatorColor,
      this.indicatorSize,
      this.unSelectedIndicatorSize,
      this.indicatorSpacing,
      this.autoSlide = true,
      this.autoSlideDuration,
      this.slideDuration,
      this.slideCurve,
      this.loadingIndicatorWidget,
      this.edgeMargin,
      this.indicatorTopPosition,
      this.indicatorRightPosition,
      this.indicatorBottomPosition,
      this.indicatorLeftPosition});

  @override
  State<WonderfulImagesCarousel> createState() =>
      _WonderfulImagesCarouselState();
}

class _WonderfulImagesCarouselState extends State<WonderfulImagesCarousel> {
  /// [currentIndex] is the current index of the carousel
  int currentIndex = 0;

  /// [_timer] is the timer for the auto slide , if [autoSlide] is true then [_timer] will be initialized
  Timer? _timer;

  /// [pageController] is the controller for the page view of the carousel
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentIndex);
    if (widget.autoSlide == true) {
      _startAutoSlide();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();

    /// cancel for the [_timer] to avoid memory leaks
    super.dispose();
  }

  void _startAutoSlide() {
    /// start the [_timer] to auto slide the carousel
    _timer = Timer.periodic(Duration(seconds: widget.autoSlideDuration ?? 6),
        (timer) {
      /// if the [currentIndex] is less than the length of the images list then increment the [currentIndex] by 1
      if (currentIndex < widget.images.length - 1) {
        /// [currentIndex] is the current index of the carousel
        currentIndex++;
      } else {
        /// if the [currentIndex] is equal to the length of the images list then set the [currentIndex] to 0
        currentIndex = 0;
      }

      /// [animateToPage] is a method to animate the page view to a specific page with a duration and a curve
      pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: widget.slideDuration ?? 300),
        curve: widget.slideCurve ?? Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /// [Clip.antiAlias] is a clip behavior to clip the container with a circular border radius
      clipBehavior: Clip.antiAlias,
      height: widget.height ?? 200,
      width: widget.width ?? double.infinity,

      /// [EdgeInsets.all] is a margin to the container
      margin: widget.edgeMargin ?? const EdgeInsets.all(16),

      /// [BoxDecoration] is a decoration to decorate the container with a border radius and a background color
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
      ),

      /// [Stack] is a widget to stack the page view and the indicator
      child: Stack(
        children: [
          /// [_generatePageView] is a method to generate the page view
          _generatePageView(),
          Positioned(
            top: widget.indicatorTopPosition,
            right: widget.indicatorRightPosition ?? 25,
            bottom: widget.indicatorBottomPosition ?? 25,
            left: widget.indicatorLeftPosition,

            /// [_generateIndicator] is a method to generate the indicator
            child: _generateIndicator(),
          ),
        ],
      ),
    );
  }

  /// [_generateIndicator] is a method to generate the indicator
  Widget _generateIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.images.length,
        (index) => Container(
          margin: EdgeInsets.all(widget.indicatorSpacing ?? 4),
          width: currentIndex == index
              ? widget.indicatorSize ?? 15
              : widget.unSelectedIndicatorSize ?? 10,
          height: currentIndex == index
              ? widget.indicatorSize ?? 15
              : widget.unSelectedIndicatorSize ?? 10,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? widget.indicatorColor ?? Theme.of(context).primaryColor
                : widget.unselectedIndicatorColor ?? Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  /// [_generatePageView] is a method to generate the page view , the page view is a widget to show the images

  Widget _generatePageView() {
    return PageView.builder(
      controller: pageController,
      itemCount: widget.images.length,
      onPageChanged: (value) {
        setState(() {
          currentIndex = value;
        });
      },
      itemBuilder: (context, index) {
        /// [CachedNetworkImage] is a widget to load the image from the network and cache it
        return CachedNetworkImage(
          alignment: Alignment.center,
          imageUrl: widget.images[index],
          placeholder: (context, url) =>
              widget.loadingIndicatorWidget ??
              const Center(
                child: CircularProgressIndicator(),
              ),
          errorWidget: (context, url, error) =>
              widget.onErrorWidget ??
              const Icon(Icons.error, color: Colors.red),
          fit: BoxFit.cover,
          height: widget.height ?? 200,
          width: widget.width ?? double.infinity,
        );
      },
    );
  }
}
