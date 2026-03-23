import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/watchlist_bloc.dart';
import '../model/stockmodel.dart';
import 'edit_watchlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            _buildIndexItem(
                "SENSEX 18TH SEP 8...", "1,225.55", "+144.50 (13.3...)", true),
            const VerticalDivider(width: 20, thickness: 1, color: Colors.grey),
            _buildIndexItem(
                "NIFTY BANK", "54,169.45", "-17.45 (-0.03...)", false),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for instruments",
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                fillColor: Colors.grey[100],
                filled: true,
              ),
            ),
          ),

          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: "Watchlist 1"),
              Tab(text: "Watchlist 2"),
              Tab(text: "Watchlist 3"),
              Tab(text: "Watchlist 4"),
              Tab(text: "Watchlist 5"),
              Tab(text: "Watchlist 6"),
            ],
          ),
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditWatchlistPage()),
                  );
                },
                icon: const Icon(Icons.filter_list, size: 18),
                label: const Text("Sort by"),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (context, state) {
                if (state is WatchlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WatchlistLoaded) {
                  return ListView.separated(
                    itemCount: state.stocks.length,
                    separatorBuilder: (context, index) =>
                    const Divider(height: 1),
                    itemBuilder: (context, index) =>
                        buildStockTile(state.stocks[index]),
                  );
                } else if (state is WatchlistError) {
                  return Center(child: Text("Error: ${state.message}"));
                }
                return const Center(child: Text("Start adding stocks!"));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on_outlined),
            label: 'GTT+',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Funds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),

    );
  }

  Widget _buildIndexItem(String title, String price, String change,
      bool isPositive) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Text(title, style: const TextStyle(
              fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(price, style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(width: 4),
              Text(change, style: TextStyle(
                  fontSize: 10, color: isPositive ? Colors.green : Colors.red)),
            ],
          ),
        ],
      ),
    );
  }


  Widget buildStockTile(Stock stock) {
    final color = stock.isPositive ? Colors.green : Colors.red;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stock.symbol, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(stock.description, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stock.price.toStringAsFixed(2),
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              Text(
                "${stock.changeValue.toStringAsFixed(2)} (${stock.changePercentage}%)",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
