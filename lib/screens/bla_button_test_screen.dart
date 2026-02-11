import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../widgets/display/bla_button.dart';

/// Test screen to demonstrate all BlaButton variations
/// 
/// This screen showcases:
/// - Primary buttons (with and without icons)
/// - Secondary buttons (with and without icons)
/// - Disabled states
class BlaButtonTestScreen extends StatelessWidget {
  const BlaButtonTestScreen({super.key});

  void _handleButtonPress(String buttonType) {
    debugPrint('$buttonType button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'BlaButton Test Screen',
          style: BlaTextStyles.heading.copyWith(
            fontSize: 20,
            color: BlaColors.neutralDark,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(BlaSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Primary Buttons
            Text(
              'Primary Buttons',
              style: BlaTextStyles.heading.copyWith(
                fontSize: 20,
                color: BlaColors.neutralDark,
              ),
            ),
            const SizedBox(height: BlaSpacings.m),
            
            // Primary button without icon
            BlaButton(
              text: 'Request to book',
              isPrimary: true,
              onPressed: () => _handleButtonPress('Primary'),
            ),
            const SizedBox(height: BlaSpacings.m),
            
            // Primary button with icon
            BlaButton(
              text: 'Request to book',
              isPrimary: true,
              icon: Icons.calendar_today,
              onPressed: () => _handleButtonPress('Primary with icon'),
            ),
            const SizedBox(height: BlaSpacings.m),
            
            // Primary button disabled
            const BlaButton(
              text: 'Request to book',
              isPrimary: true,
              isEnabled: false,
            ),
            
            const SizedBox(height: BlaSpacings.xl),
            
            // Section: Secondary Buttons
            Text(
              'Secondary Buttons',
              style: BlaTextStyles.heading.copyWith(
                fontSize: 20,
                color: BlaColors.neutralDark,
              ),
            ),
            const SizedBox(height: BlaSpacings.m),
            
            // Secondary button without icon
            BlaButton(
              text: 'Contact Volodia',
              isPrimary: false,
              onPressed: () => _handleButtonPress('Secondary'),
            ),
            const SizedBox(height: BlaSpacings.m),
            
            // Secondary button with icon
            BlaButton(
              text: 'Contact Volodia',
              isPrimary: false,
              icon: Icons.chat_bubble_outline,
              onPressed: () => _handleButtonPress('Secondary with icon'),
            ),
            const SizedBox(height: BlaSpacings.m),
            
            // Secondary button disabled
            const BlaButton(
              text: 'Contact Volodia',
              isPrimary: false,
              isEnabled: false,
            ),
            
            const SizedBox(height: BlaSpacings.xl),
            
            // Section: Various Icons
            Text(
              'With Various Icons',
              style: BlaTextStyles.heading.copyWith(
                fontSize: 20,
                color: BlaColors.neutralDark,
              ),
            ),
            const SizedBox(height: BlaSpacings.m),
            
            BlaButton(
              text: 'Send Message',
              isPrimary: true,
              icon: Icons.send,
              onPressed: () => _handleButtonPress('Send'),
            ),
            const SizedBox(height: BlaSpacings.m),
            
            BlaButton(
              text: 'Add to Favorites',
              isPrimary: false,
              icon: Icons.favorite_border,
              onPressed: () => _handleButtonPress('Favorite'),
            ),
            const SizedBox(height: BlaSpacings.m),
            
            BlaButton(
              text: 'Share Ride',
              isPrimary: true,
              icon: Icons.share,
              onPressed: () => _handleButtonPress('Share'),
            ),
            const SizedBox(height: BlaSpacings.m),
            
            BlaButton(
              text: 'View Profile',
              isPrimary: false,
              icon: Icons.person_outline,
              onPressed: () => _handleButtonPress('Profile'),
            ),
            
            const SizedBox(height: BlaSpacings.xxl),
          ],
        ),
      ),
    );
  }
}
