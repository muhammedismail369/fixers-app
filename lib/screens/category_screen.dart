import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;

  const CategoryScreen({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(categoryName),
            centerTitle: true,
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SearchBar(
                hintText: 'Search service providers...',
                leading: Icon(Icons.search),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: categoryColor.withOpacity(0.2),
                        child: Icon(categoryIcon, color: categoryColor),
                      ),
                      title: Text('Service Provider ${index + 1}'),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const Text(' 4.5 • '),
                          Text('${(index + 1) * 5} jobs completed'),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to service provider details
                      },
                    ),
                  );
                },
                childCount: 10, // Dummy count
              ),
            ),
          ),
        ],
      ),
    );
  }
}
