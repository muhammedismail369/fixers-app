import 'package:flutter/material.dart';
import 'create_booking_screen.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar.medium(
                title: const Text('My Bookings'),
                centerTitle: true,
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Active Bookings'),
                    Tab(text: 'Job History'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _BookingList(
                bookings: _getDummyActiveBookings(),
                isHistory: false,
              ),
              _BookingList(
                bookings: _getDummyBookingHistory(),
                isHistory: true,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateBookingScreen(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('New Booking'),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getDummyActiveBookings() {
    return [
      {
        'id': '1',
        'service': 'Plumbing',
        'date': DateTime.now().add(const Duration(days: 2)),
        'status': 'Scheduled',
        'location': '123 Main St',
        'description': 'Leaking faucet repair',
        'urgency': 'Normal',
      },
      {
        'id': '2',
        'service': 'Electrical',
        'date': DateTime.now().add(const Duration(days: 1)),
        'status': 'Confirmed',
        'location': '456 Oak Ave',
        'description': 'Power outlet installation',
        'urgency': 'Urgent',
      },
    ];
  }

  List<Map<String, dynamic>> _getDummyBookingHistory() {
    return [
      {
        'id': '3',
        'service': 'Carpentry',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'status': 'Completed',
        'location': '789 Pine Rd',
        'description': 'Cabinet repair',
        'rating': 4.5,
      },
      {
        'id': '4',
        'service': 'Cleaning',
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'status': 'Completed',
        'location': '321 Elm St',
        'description': 'Deep house cleaning',
        'rating': 5.0,
      },
    ];
  }
}

class _BookingList extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;
  final bool isHistory;

  const _BookingList({
    required this.bookings,
    required this.isHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isHistory ? Icons.history : Icons.calendar_today,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isHistory ? 'No booking history yet' : 'No active bookings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isHistory
                  ? 'Your completed bookings will appear here'
                  : 'Create a new booking to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              ListTile(
                leading: _getServiceIcon(booking['service']),
                title: Text(booking['service']),
                subtitle: Text(
                  '${booking['location']}\n${booking['description']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: _buildStatusChip(booking['status']),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date & Time',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDateTime(booking['date']),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    if (isHistory && booking['rating'] != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            booking['rating'].toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      )
                    else if (!isHistory)
                      FilledButton.icon(
                        onPressed: () {
                          // TODO: Implement booking details/actions
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Manage'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getServiceIcon(String service) {
    IconData iconData;
    switch (service.toLowerCase()) {
      case 'plumbing':
        iconData = Icons.plumbing;
        break;
      case 'electrical':
        iconData = Icons.electrical_services;
        break;
      case 'carpentry':
        iconData = Icons.carpenter;
        break;
      case 'cleaning':
        iconData = Icons.cleaning_services;
        break;
      default:
        iconData = Icons.home_repair_service;
    }
    return CircleAvatar(
      child: Icon(iconData),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'scheduled':
        backgroundColor = Colors.blue;
        break;
      case 'confirmed':
        backgroundColor = Colors.green;
        break;
      case 'completed':
        backgroundColor = Colors.grey;
        break;
      case 'cancelled':
        backgroundColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: textColor, fontSize: 12),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}\n${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
