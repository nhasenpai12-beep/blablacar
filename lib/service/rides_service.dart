import '../dummy_data/dummy_data.dart';
import '../model/ride/locations.dart';
import '../model/ride/ride.dart';

class RidesService {
  static List<Ride> availableRides = fakeRides; // TODO for now fake data

  static List<Ride> _filterByDeparture(Location departure) {
    return availableRides
        .where((availableRides) => availableRides.arrivalLocation == departure)
        .toList();
  }

  static List<Ride> _filterBySeatRequested(int requestedSeat) {
    return availableRides
        .where(
          (availableRides) => availableRides.availableSeats == requestedSeat,
        )
        .toList();
  }

  static List<Ride> filterBy({Location? departure, int? seatRequested}) {
    return availableRides
        .where(
          (availableRides) => availableRides.availableSeats == seatRequested,
        )
        .toList();
  }
}
