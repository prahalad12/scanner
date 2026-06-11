import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/profile_screen.dart';
import '../theme.dart';

class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const SizedBox(), // Sell — handled via modal
    const MessagesScreen(),
    const ProfileScreen(),
  ];

  void _onNavTap(int index) {
    if (index == 2) {
      _showSellSheet();
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _showSellSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SellSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: YwcTheme.surface2,
        border: Border(top: BorderSide(color: YwcTheme.borderColor, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                selected: _currentIndex == 0,
                onTap: () => _onNavTap(0),
              ),
              _NavItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search_rounded,
                label: 'Search',
                selected: _currentIndex == 1,
                onTap: () => _onNavTap(1),
              ),
              _SellButton(onTap: () => _onNavTap(2)),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Messages',
                selected: _currentIndex == 3,
                badge: true,
                onTap: () => _onNavTap(3),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                selected: _currentIndex == 4,
                onTap: () => _onNavTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final bool badge;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    this.badge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    selected ? activeIcon : icon,
                    key: ValueKey(selected),
                    size: 22,
                    color: selected ? YwcTheme.teal : YwcTheme.text3,
                  ),
                ),
                if (badge)
                  Positioned(
                    right: -3,
                    top: -3,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: YwcTheme.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? YwcTheme.teal : YwcTheme.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SellButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SellButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [YwcTheme.teal, YwcTheme.navy],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: YwcTheme.teal.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SellSheet extends StatefulWidget {
  const _SellSheet();

  @override
  State<_SellSheet> createState() => _SellSheetState();
}

class _SellSheetState extends State<_SellSheet> {
  int _step = 0;
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String _condition = 'good';
  String _category = 'uniforms';

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: YwcTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildSheetHeader(),
          if (_step == 0) _buildStep0(),
          if (_step == 1) _buildStep1(),
        ],
      ),
    );
  }

  Widget _buildHandle() => Center(
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 0),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: YwcTheme.borderColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );

  Widget _buildSheetHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
        child: Row(
          children: [
            if (_step > 0)
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    size: 20, color: YwcTheme.navy),
                onPressed: () => setState(() => _step--),
              )
            else
              const SizedBox(width: 40),
            Expanded(
              child: Text(
                _step == 0 ? 'List an Item' : 'Details',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: YwcTheme.navy,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded,
                  size: 20, color: YwcTheme.text3),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

  Widget _buildStep0() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo upload area
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: YwcTheme.teal.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: YwcTheme.teal.withValues(alpha: 0.3),
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 32, color: YwcTheme.teal.withValues(alpha: 0.6)),
                  const SizedBox(height: 8),
                  Text(
                    'Add Photos',
                    style: TextStyle(
                      color: YwcTheme.teal.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Up to 5 photos',
                    style: TextStyle(
                        color: YwcTheme.text3.withValues(alpha: 0.8),
                        fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'e.g. Female Interior Uniform Set',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (£)',
                    hintText: '0.00',
                    prefixText: '£ ',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: const [
                    DropdownMenuItem(value: 'uniforms', child: Text('Uniforms')),
                    DropdownMenuItem(value: 'safety', child: Text('Safety')),
                    DropdownMenuItem(
                        value: 'electronics', child: Text('Electronics')),
                    DropdownMenuItem(value: 'gear', child: Text('Gear')),
                    DropdownMenuItem(value: 'books', child: Text('Books')),
                  ],
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => setState(() => _step = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: YwcTheme.navy,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    const conditions = [
      ('new', 'New'),
      ('like_new', 'Like New'),
      ('good', 'Good'),
      ('fair', 'Fair'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Condition',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: YwcTheme.text2,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: conditions.map((c) {
              final selected = _condition == c.$1;
              return ChoiceChip(
                label: Text(c.$2),
                selected: selected,
                onSelected: (_) => setState(() => _condition = c.$1),
                selectedColor: YwcTheme.navy,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : YwcTheme.text2,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: YwcTheme.surface2,
                side: BorderSide(
                  color: selected ? YwcTheme.navy : YwcTheme.borderColor,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText:
                  'Describe size, condition details, reason for selling...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Listing submitted for review!'),
                    backgroundColor: YwcTheme.teal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: YwcTheme.teal,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Post Listing',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}