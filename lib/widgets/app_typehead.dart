import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AppTypeAhead<T> extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final List<T> items;
  final String Function(T) itemToString;
  final void Function(T) onSelected;

  const AppTypeAhead({
    super.key,
    required this.controller,
    required this.hintText,
    required this.items,
    required this.itemToString,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      controller: controller,

      // 🔹 TextField UI
      builder: (context, textController, focusNode) {
        return TextField(
          controller: textController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        );
      },

      // 🔹 Suggestions logic
      suggestionsCallback: (pattern) {
        if (pattern.isEmpty) {
          return items; // show all items
        }

        return items
            .where((item) => itemToString(item)
                .toLowerCase()
                .contains(pattern.toLowerCase()))
            .toList(); // ✅ FIXED
      },

      // 🔹 Suggestion UI
      itemBuilder: (context, item) {
        return ListTile(
          title: Text(itemToString(item)),
        );
      },

      // 🔹 On select
      onSelected: (item) {
        controller.text = itemToString(item);
        onSelected(item);
      },

      // 🔹 Optional UX improvements
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(12),
        child: Text("No results found"),
      ),

      loadingBuilder: (context) => const Padding(
        padding: EdgeInsets.all(12),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}