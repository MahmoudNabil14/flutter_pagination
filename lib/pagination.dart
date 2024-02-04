library pagination;

import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  const Pagination(
      {super.key,

      /// Total number of pages
      required this.numOfPages,

      /// Current selected page
      required this.selectedPage,

      /// Number of pages visible in the widget between the previous and next buttons
      required this.pagesVisible,

      /// Callback function when a page is selected
      required this.onPageChanged,

      /// Style for the active page text
      required this.activeTextStyle,

      /// Style for the active page button
      this.activeBtnStyle,

      /// Style for the inactive page text
      required this.inactiveTextStyle,

      /// Style for the inactive page button
      this.inactiveBtnStyle,

      /// Icon for the previous button
      required this.previousIcon,

      /// Icon for the next button
      required this.nextIcon,

      /// Icon for the first button
      required this.firstIcon,

      /// Icon for the last button
      required this.lastIcon,

      /// Size for all buttons *all buttons squares*
      required this.buttonsSize,

      /// Inactive border color for all buttons
      required this.buttonsInactiveBorderColor,

      /// Color for selected page button
      required this.activePageButtonColor,

      /// Border radius for all buttons
      required this.buttonsBorderRadius,

      /// Spacing between the individual page buttons
      this.spacing});

  final int numOfPages;
  final int selectedPage;
  final int pagesVisible;
  final double buttonsSize;
  final Function onPageChanged;
  final TextStyle activeTextStyle;
  final ButtonStyle? activeBtnStyle;
  final TextStyle inactiveTextStyle;
  final ButtonStyle? inactiveBtnStyle;
  final Color buttonsInactiveBorderColor;
  final Color activePageButtonColor;
  final double buttonsBorderRadius;
  final Widget previousIcon;
  final Widget lastIcon;
  final Widget nextIcon;
  final Widget firstIcon;
  final double? spacing;

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  late int _startPage;
  late int _endPage;

  @override
  void initState() {
    super.initState();
    _calculateVisiblePages();
  }

  @override
  void didUpdateWidget(Pagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculateVisiblePages();
  }

  void _calculateVisiblePages() {
    /// If the number of pages is less than or equal to the number of pages visible, then show all the pages
    if (widget.numOfPages <= widget.pagesVisible) {
      _startPage = 1;
      _endPage = widget.numOfPages;
    } else {
      /// If the number of pages is greater than the number of pages visible, then show the pages visible
      int middle = (widget.pagesVisible - 1) ~/ 2;
      if (widget.selectedPage <= middle + 1) {
        _startPage = 1;
        _endPage = widget.pagesVisible;
      } else if (widget.selectedPage >= widget.numOfPages - middle) {
        _startPage = widget.numOfPages - (widget.pagesVisible - 1);
        _endPage = widget.numOfPages;
      } else {
        _startPage = widget.selectedPage - middle;
        _endPage = widget.selectedPage + middle;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Previous button
        GestureDetector(
          onTap: widget.selectedPage > 1 ? () => widget.onPageChanged(1) : null,
          child: Container(
            width: widget.buttonsSize,
            height: widget.buttonsSize,
            margin: EdgeInsets.symmetric(horizontal: widget.spacing ?? 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.buttonsBorderRadius),
              border: Border.all(color: widget.buttonsInactiveBorderColor),
            ),
            child: Center(
              child: widget.firstIcon,
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.selectedPage > 1 ? () => widget.onPageChanged(widget.selectedPage - 1) : null,
          child: Container(
            width: widget.buttonsSize,
            height: widget.buttonsSize,
            margin: EdgeInsets.symmetric(horizontal: widget.spacing ?? 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.buttonsBorderRadius),
              border: Border.all(color: widget.buttonsInactiveBorderColor),
            ),
            child: Center(
              child: widget.previousIcon,
            ),
          ),
        ),

        /// loop through the pages and show the page buttons
        for (int i = _startPage; i <= _endPage; i++)
          AnimatedContainer(
            width: widget.buttonsSize,
            height: widget.buttonsSize,
            margin: EdgeInsets.symmetric(horizontal: widget.spacing ?? 0),
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: i == widget.selectedPage ? widget.activePageButtonColor : Colors.white,
              borderRadius: BorderRadius.circular(widget.buttonsBorderRadius),
              border: Border.all(color: i == widget.selectedPage ? widget.activePageButtonColor : widget.buttonsInactiveBorderColor),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () => widget.onPageChanged(i),
                child: Text(
                  '$i',
                  textAlign: TextAlign.center,
                  style: i == widget.selectedPage ? widget.activeTextStyle : widget.inactiveTextStyle,
                ),
              ),
            ),
          ),
        if (widget.selectedPage < widget.numOfPages - 1)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: widget.spacing ?? 0),
                width: widget.buttonsSize,
                child: const Text(
                  '...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF333333), fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                width: widget.spacing ?? 0,
              ),
              AnimatedContainer(
                width: widget.buttonsSize,
                height: widget.buttonsSize,
                margin: EdgeInsets.symmetric(horizontal: widget.spacing ?? 0),
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(widget.buttonsBorderRadius),
                  border: Border.all(color: widget.buttonsInactiveBorderColor),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () => widget.onPageChanged(widget.numOfPages),
                    child: Text(
                      '${widget.numOfPages}',
                      textAlign: TextAlign.center,
                      style: widget.inactiveTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),

        /// Next buttons
        GestureDetector(
          onTap: widget.selectedPage < widget.numOfPages ? () => widget.onPageChanged(widget.selectedPage + 1) : null,
          child: Container(
            width: widget.buttonsSize,
            height: widget.buttonsSize,
            margin: EdgeInsets.symmetric(horizontal: widget.spacing ?? 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.buttonsBorderRadius),
              border: Border.all(color: widget.buttonsInactiveBorderColor),
            ),
            child: Center(child: widget.nextIcon),
          ),
        ),
        GestureDetector(
          onTap: widget.selectedPage < widget.numOfPages ? () => widget.onPageChanged(widget.numOfPages) : null,
          child: Container(
            width: widget.buttonsSize,
            height: widget.buttonsSize,
            margin: EdgeInsets.symmetric(horizontal: widget.spacing ?? 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.buttonsBorderRadius),
              border: Border.all(color: widget.buttonsInactiveBorderColor),
            ),
            child: Center(child: widget.lastIcon),
          ),
        )
      ],
    );
  }
}
