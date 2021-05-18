import 'dart:math';

import 'package:flutter/material.dart';

class DynamicTextHighlighting extends StatelessWidget {
  final String text;
  final List<String> highlights;
  final TextStyle style;
  final bool caseSensitive;
  final TextOverflow overflow;
  final int maxLines;

  DynamicTextHighlighting({
    Key key,
    this.text,
    this.highlights,
    this.style,
    this.maxLines,
    this.overflow,
    this.caseSensitive = true,
  });

  @override
  Widget build(BuildContext context) {
    if (text == '') {
      return _richText(_normalSpan(text));
    }
    if (highlights.isEmpty) {
      return _richText(_normalSpan(text));
    }
    for (int i = 0; i < highlights.length; i++) {
      if (highlights[i] == null) {
        assert(highlights[i] != null);
        return _richText(_normalSpan(text));
      }
      if (highlights[i].isEmpty) {
        assert(highlights[i].isNotEmpty);
        return _richText(_normalSpan(text));
      }
    }

    List<TextSpan> _spans = [];
    int _start = 0;

    String _lowerCaseText = text.toLowerCase();
    List<String> _lowerCaseHighlights = [];

    highlights.forEach((element) {
      _lowerCaseHighlights.add(element.toLowerCase());
    });

    while (true) {
      Map<int, String> _highlightsMap = Map();

      if (caseSensitive) {
        for (int i = 0; i < highlights.length; i++) {
          int _index = text.indexOf(highlights[i], _start);
          if (_index >= 0) {
            _highlightsMap.putIfAbsent(_index, () => highlights[i]);
          }
        }
      } else {
        for (int i = 0; i < highlights.length; i++) {
          int _index = _lowerCaseText.indexOf(_lowerCaseHighlights[i], _start);
          if (_index >= 0) {
            _highlightsMap.putIfAbsent(_index, () => highlights[i]);
          }
        }
      }

      if (_highlightsMap.isNotEmpty) {
        List<int> _indexes = [];
        _highlightsMap.forEach((key, value) => _indexes.add(key));

        int _currentIndex = _indexes.reduce(min);
        String _currentHighlight = text.substring(_currentIndex,
            _currentIndex + _highlightsMap[_currentIndex].length);

        if (_currentIndex == _start) {
          _spans.add(_highlightSpan(_currentHighlight));
          _start += _currentHighlight.length;
        } else {
          _spans.add(_normalSpan(text.substring(_start, _currentIndex)));
          _spans.add(_highlightSpan(_currentHighlight));
          _start = _currentIndex + _currentHighlight.length;
        }
      } else {
        _spans.add(_normalSpan(text.substring(_start, text.length)));
        break;
      }
    }

    return _richText(TextSpan(children: _spans));
  }

  TextSpan _highlightSpan(String value) {
    return TextSpan(
      text: value,
      style: style.copyWith(
        color: Colors.red,
      ),
    );
  }

  TextSpan _normalSpan(String value) {
    return TextSpan(
      text: value,
      style: style,
    );
  }

  RichText _richText(TextSpan text) {
    return RichText(
      key: key,
      text: text,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
