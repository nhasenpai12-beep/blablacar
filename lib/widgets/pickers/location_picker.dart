import 'package:flutter/material.dart';
import '../../model/ride/locations.dart';
import '../../theme/theme.dart';

/// LocationPicker - A searchable location picker widget.
/// 
/// Displays a full-screen modal with:
/// - Search bar for filtering locations
/// - Scrollable list of matching locations
/// - Location name and country display
/// 
/// Returns the selected Location when user taps on it.
class LocationPicker extends StatefulWidget {
  /// Title displayed at the top
  final String title;
  
  /// List of available locations to choose from
  final List<Location> locations;
  
  /// Optional initially selected location
  final Location? selectedLocation;

  const LocationPicker({
    super.key,
    required this.title,
    required this.locations,
    this.selectedLocation,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();

  /// Static method to show the picker as a modal
  static Future<Location?> show({
    required BuildContext context,
    required String title,
    required List<Location> locations,
    Location? selectedLocation,
  }) {
    return showModalBottomSheet<Location>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(BlaSpacings.radiusLarge),
        ),
      ),
      builder: (context) => LocationPicker(
        title: title,
        locations: locations,
        selectedLocation: selectedLocation,
      ),
    );
  }
}

class _LocationPickerState extends State<LocationPicker> {
  late TextEditingController _searchController;
  late List<Location> _filteredLocations;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _filteredLocations = widget.locations;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = widget.locations;
      } else {
        _filteredLocations = widget.locations.where((location) {
          return location.name.toLowerCase().contains(query) ||
              location.country.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _onLocationSelected(Location location) {
    Navigator.pop(context, location);
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header with dismiss handle
            Container(
              padding: const EdgeInsets.symmetric(vertical: BlaSpacings.s),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BlaColors.greyLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: BlaSpacings.l,
                vertical: BlaSpacings.s,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: BlaTextStyles.heading.copyWith(
                        fontSize: 20,
                        color: BlaColors.neutralDark,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: BlaColors.iconNormal),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: BlaSpacings.l,
                vertical: BlaSpacings.s,
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: true,
                style: BlaTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  hintStyle: BlaTextStyles.body.copyWith(
                    color: BlaColors.neutralLighter,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: BlaColors.iconLight,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: BlaColors.iconLight),
                          onPressed: _clearSearch,
                        )
                      : null,
                  filled: true,
                  fillColor: BlaColors.backgroundAccent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(BlaSpacings.radius),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: BlaSpacings.m,
                    vertical: BlaSpacings.s,
                  ),
                ),
              ),
            ),

            // Location list
            Expanded(
              child: _filteredLocations.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _filteredLocations.length,
                      itemBuilder: (context, index) {
                        final location = _filteredLocations[index];
                        final isSelected =
                            location == widget.selectedLocation;
                        return _LocationTile(
                          location: location,
                          isSelected: isSelected,
                          onTap: () => _onLocationSelected(location),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BlaSpacings.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: BlaColors.neutralLighter,
            ),
            const SizedBox(height: BlaSpacings.m),
            Text(
              'No locations found',
              style: BlaTextStyles.body.copyWith(
                color: BlaColors.textLight,
              ),
            ),
            const SizedBox(height: BlaSpacings.s),
            Text(
              'Try a different search term',
              style: BlaTextStyles.label.copyWith(
                color: BlaColors.neutralLighter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual location tile in the list
class _LocationTile extends StatelessWidget {
  final Location location;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationTile({
    required this.location,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: BlaSpacings.l,
          vertical: BlaSpacings.m,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: BlaColors.greyLight,
              width: 1,
            ),
          ),
          color: isSelected ? BlaColors.backgroundAccent : Colors.transparent,
        ),
        child: Row(
          children: [
            // Radio button indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? BlaColors.primary : BlaColors.greyLight,
                  width: 2,
                ),
                color: isSelected ? BlaColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.circle,
                      size: 10,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: BlaSpacings.m),

            // Location info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: BlaTextStyles.body.copyWith(
                      color: BlaColors.textNormal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    location.country.name,
                    style: BlaTextStyles.label.copyWith(
                      color: BlaColors.textLight,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right,
              color: BlaColors.iconLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
