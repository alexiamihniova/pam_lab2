import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

// Bara de căutare cu buton de filtre
class SearchField extends StatefulWidget {
  final String hint;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final bool filtersActive;

  const SearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.onFilterTap,
    this.initialValue = '',
    this.filtersActive = false,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void didUpdateWidget(SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sincronizează textul când filtrele sunt resetate din exterior
    if (widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textGrey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(color: AppColors.textGrey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.close,
                color: AppColors.textGrey,
                size: 20,
              ),
              onPressed: () {
                _controller.clear();
                widget.onChanged('');
              },
            ),
          IconButton(
            tooltip: 'Filters & sort',
            onPressed: widget.onFilterTap,
            icon: Badge(
              isLabelVisible: widget.filtersActive,
              smallSize: 8,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.tune, color: AppColors.textGrey),
            ),
          ),
        ],
      ),
    );
  }
}
