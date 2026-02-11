import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../dummy_data/dummy_data.dart';
import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../theme/theme.dart';
import '../../../widgets/display/bla_button.dart';
import '../../../widgets/display/bla_input_field.dart';
import '../../../widgets/pickers/location_picker.dart';

///
/// A Ride Preference Form is a view to select:
///   - A departure location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
/// When the Search button is pressed, it returns a RidePref via the onSearch callback.
///
class RidePrefForm extends StatefulWidget {
  /// The form can be created with an optional initial RidePref.
  final RidePref? initRidePref;
  
  /// Callback when the search button is pressed with valid data
  final Function(RidePref)? onSearch;

  const RidePrefForm({super.key, this.initRidePref, this.onSearch});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  DateTime? departureDate;
  Location? arrival;
  int requestedSeats = 1; // Default to 1 passenger

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  @override
  void initState() {
    super.initState();
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      departureDate = widget.initRidePref!.departureDate;
      arrival = widget.initRidePref!.arrival;
      requestedSeats = widget.initRidePref!.requestedSeats;
    }
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------

  void _handleDepartureSelect() async {
    final selected = await LocationPicker.show(
      context: context,
      title: 'Select Departure',
      locations: fakeLocations,
      selectedLocation: departure,
    );
    if (selected != null) {
      setState(() {
        departure = selected;
      });
    }
  }

  void _handleArrivalSelect() async {
    final selected = await LocationPicker.show(
      context: context,
      title: 'Select Arrival',
      locations: fakeLocations,
      selectedLocation: arrival,
    );
    if (selected != null) {
      setState(() {
        arrival = selected;
      });
    }
  }

  void _handleSwapLocations() {
    if (departure != null || arrival != null) {
      setState(() {
        final temp = departure;
        departure = arrival;
        arrival = temp;
      });
    }
  }

  void _handleDateSelect() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: departureDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) {
      setState(() {
        departureDate = selected;
      });
    }
  }

  void _handlePassengersSelect() async {
    final selected = await showDialog<int>(
      context: context,
      builder: (context) => _PassengerPicker(currentValue: requestedSeats),
    );
    if (selected != null) {
      setState(() {
        requestedSeats = selected;
      });
    }
  }

  void _handleSearch() {
    if (_isFormValid()) {
      final ridePref = RidePref(
        departure: departure!,
        departureDate: departureDate!,
        arrival: arrival!,
        requestedSeats: requestedSeats,
      );
      
      if (widget.onSearch != null) {
        widget.onSearch!(ridePref);
      }
    }
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------

  bool _isFormValid() {
    return departure != null && arrival != null && departureDate != null;
  }

  String? _getDateDisplayText() {
    if (departureDate == null) return null;
    return DateFormat('E d MMM').format(departureDate!); // "Sat 22 Feb"
  }

  // ----------------------------------
  // Build the widgets
  // ----------------------------------

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Departure location
        BlaInputField(
          icon: Icons.radio_button_checked,
          placeholder: 'Departure location',
          value: departure?.name,
          onTap: _handleDepartureSelect,
        ),

        // Arrival location (with swap button)
        BlaInputField(
          icon: Icons.location_on,
          placeholder: 'Arrival location',
          value: arrival?.name,
          onTap: _handleArrivalSelect,
          trailingWidget: IconButton(
            icon: Icon(
              Icons.swap_vert,
              color: BlaColors.primary,
            ),
            onPressed: _handleSwapLocations,
          ),
        ),

        // Departure date
        BlaInputField(
          icon: Icons.calendar_today,
          placeholder: 'Select date',
          value: _getDateDisplayText(),
          onTap: _handleDateSelect,
        ),

        // Number of passengers
        BlaInputField(
          icon: Icons.person,
          placeholder: 'Passengers',
          value: requestedSeats.toString(),
          onTap: _handlePassengersSelect,
        ),

        // Search button
        Padding(
          padding: const EdgeInsets.all(BlaSpacings.m),
          child: BlaButton(
            text: 'Search',
            isPrimary: true,
            isEnabled: _isFormValid(),
            onPressed: _handleSearch,
          ),
        ),
      ],
    );
  }
}

// ----------------------------------
// Passenger Picker Dialog
// ----------------------------------

class _PassengerPicker extends StatelessWidget {
  final int currentValue;

  const _PassengerPicker({required this.currentValue});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Number of passengers',
        style: BlaTextStyles.heading.copyWith(fontSize: 20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(8, (index) {
          final passengers = index + 1;
          return ListTile(
            title: Text(
              '$passengers passenger${passengers > 1 ? 's' : ''}',
              style: BlaTextStyles.body,
            ),
            selected: passengers == currentValue,
            selectedTileColor: BlaColors.backgroundAccent,
            onTap: () => Navigator.pop(context, passengers),
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: BlaTextStyles.button.copyWith(color: BlaColors.primary),
          ),
        ),
      ],
    );
  }
}
