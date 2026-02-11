import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// BlaInputField - A reusable input field widget for the BlaBlaCar app.
/// 
/// Displays a text field with:
/// - Leading icon
/// - Placeholder text
/// - Optional trailing widget
/// - Tap callback for custom behavior (e.g., showing pickers)
class BlaInputField extends StatelessWidget {
  /// The icon displayed on the left side
  final IconData icon;
  
  /// The text to display when no value is selected
  final String placeholder;
  
  /// The current value to display
  final String? value;
  
  /// Callback when the field is tapped
  final VoidCallback? onTap;
  
  /// Optional widget to display on the right side (e.g., swap button)
  final Widget? trailingWidget;
  
  /// Whether this field is enabled
  final bool enabled;

  const BlaInputField({
    super.key,
    required this.icon,
    required this.placeholder,
    this.value,
    this.onTap,
    this.trailingWidget,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = value ?? placeholder;
    final textColor = value != null 
        ? BlaColors.textNormal 
        : BlaColors.neutralLighter;
    
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: BlaSpacings.m,
          vertical: BlaSpacings.m,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: BlaColors.greyLight,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Leading icon
            Icon(
              icon,
              size: 20,
              color: BlaColors.iconLight,
            ),
            const SizedBox(width: BlaSpacings.m),
            
            // Text value/placeholder
            Expanded(
              child: Text(
                displayText,
                style: BlaTextStyles.body.copyWith(
                  color: textColor,
                ),
              ),
            ),
            
            // Optional trailing widget
            if (trailingWidget != null) trailingWidget!,
          ],
        ),
      ),
    );
  }
}
