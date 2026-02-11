import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// BlaButton - A reusable button widget for the BlaBlaCar app.
/// 
/// Supports:
/// - Primary (filled) and Secondary (outlined) styles
/// - Optional leading icon
/// - Enabled/Disabled states
/// - Customizable callback
class BlaButton extends StatelessWidget {
  /// The text displayed on the button
  final String text;
  
  /// Callback function when button is pressed
  final VoidCallback? onPressed;
  
  /// If true, displays primary style (filled), otherwise secondary style (outlined)
  final bool isPrimary;
  
  /// Optional icon to display before the text
  final IconData? icon;
  
  /// Controls whether the button is enabled or disabled
  final bool isEnabled;

  const BlaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isEnabled ? onPressed : null;
    
    if (isPrimary) {
      return _buildPrimaryButton(effectiveOnPressed);
    } else {
      return _buildSecondaryButton(effectiveOnPressed);
    }
  }

  /// Builds a primary (filled) button
  Widget _buildPrimaryButton(VoidCallback? callback) {
    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? BlaColors.primary : BlaColors.disabled,
        foregroundColor: BlaColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: BlaSpacings.l,
          vertical: BlaSpacings.m,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BlaSpacings.radius),
        ),
        minimumSize: const Size(double.infinity, 56),
      ),
      child: _buildButtonContent(BlaColors.white),
    );
  }

  /// Builds a secondary (outlined) button
  Widget _buildSecondaryButton(VoidCallback? callback) {
    return OutlinedButton(
      onPressed: callback,
      style: OutlinedButton.styleFrom(
        foregroundColor: isEnabled ? BlaColors.primary : BlaColors.disabled,
        side: BorderSide(
          color: isEnabled ? BlaColors.primary : BlaColors.disabled,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: BlaSpacings.l,
          vertical: BlaSpacings.m,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BlaSpacings.radius),
        ),
        minimumSize: const Size(double.infinity, 56),
      ),
      child: _buildButtonContent(
        isEnabled ? BlaColors.primary : BlaColors.disabled,
      ),
    );
  }

  /// Builds the content of the button (icon + text)
  Widget _buildButtonContent(Color color) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: BlaSpacings.s),
          Text(
            text,
            style: BlaTextStyles.button.copyWith(color: color),
          ),
        ],
      );
    }
    
    return Text(
      text,
      style: BlaTextStyles.button.copyWith(color: color),
    );
  }
}
