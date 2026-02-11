import 'package:flutter/material.dart';

import '../../dummy_data/dummy_data.dart';
import '../../model/ride/ride.dart';
import '../../theme/theme.dart';
import '../../widgets/display/bla_button.dart';
import '../../utils/date_time_util.dart';

///
/// This screen displays available rides matching the user's search.
/// Users can view ride details and take actions like booking or contacting the driver.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using fake rides for demonstration
    final rides = fakeRides.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Available Rides',
          style: BlaTextStyles.heading.copyWith(
            fontSize: 20,
            color: BlaColors.neutralDark,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: BlaColors.neutralDark),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(BlaSpacings.m),
        itemCount: rides.length,
        itemBuilder: (context, index) {
          final ride = rides[index];
          return _RideCard(ride: ride);
        },
      ),
    );
  }
}

///
/// Card widget displaying a single ride with booking/contact actions
///
class _RideCard extends StatelessWidget {
  final Ride ride;

  const _RideCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: BlaSpacings.m),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BlaSpacings.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(BlaSpacings.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.departureLocation.name,
                        style: BlaTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: BlaColors.neutralDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateTimeUtils.formatDateTime(ride.departureDate),
                        style: BlaTextStyles.label.copyWith(
                          color: BlaColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: BlaColors.iconLight, size: 20),
                const SizedBox(width: BlaSpacings.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.arrivalLocation.name,
                        style: BlaTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: BlaColors.neutralDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateTimeUtils.formatDateTime(ride.arrivalDateTime),
                        style: BlaTextStyles.label.copyWith(
                          color: BlaColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: BlaSpacings.m),

            // Driver info
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(ride.driver.profilePicture),
                ),
                const SizedBox(width: BlaSpacings.s),
                Text(
                  ride.driver.firstName,
                  style: BlaTextStyles.body.copyWith(
                    color: BlaColors.neutralDark,
                  ),
                ),
                const Spacer(),
                Icon(Icons.person, size: 16, color: BlaColors.iconLight),
                const SizedBox(width: 4),
                Text(
                  '${ride.availableSeats} seat${ride.availableSeats > 1 ? 's' : ''}',
                  style: BlaTextStyles.label.copyWith(
                    color: BlaColors.textLight,
                  ),
                ),
                const SizedBox(width: BlaSpacings.m),
                Text(
                  '€${ride.pricePerSeat.toStringAsFixed(0)}',
                  style: BlaTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: BlaColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: BlaSpacings.m),

            // Action buttons
            BlaButton(
              text: 'Request to book',
              isPrimary: true,
              icon: Icons.calendar_today,
              onPressed: () {
                // Handle booking request
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking request sent to ${ride.driver.firstName}'),
                  ),
                );
              },
            ),

            const SizedBox(height: BlaSpacings.s),

            BlaButton(
              text: 'Contact ${ride.driver.firstName}',
              isPrimary: false,
              icon: Icons.chat_bubble_outline,
              onPressed: () {
                // Handle contact action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening chat with ${ride.driver.firstName}'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
