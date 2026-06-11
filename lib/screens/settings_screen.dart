import 'package:flutter/material.dart';
import '../theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = true;
  bool _messageNotifications = true;
  bool _darkMode = false;
  String _currency = 'GBP';
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YwcTheme.surface,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                _SGroup(
                  title: 'Account',
                  children: [
                    _STile(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profile',
                      onTap: () {},
                    ),
                    _STile(
                      icon: Icons.lock_outline_rounded,
                      label: 'Change Password',
                      onTap: () {},
                    ),
                    _STile(
                      icon: Icons.verified_user_outlined,
                      label: 'Identity Verification',
                      trailing: _badge('Pending', YwcTheme.gold),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SGroup(
                  title: 'Notifications',
                  children: [
                    _SToggle(
                      icon: Icons.notifications_outlined,
                      label: 'Push Notifications',
                      value: _pushNotifications,
                      onChanged: (v) =>
                          setState(() => _pushNotifications = v),
                    ),
                    _SToggle(
                      icon: Icons.email_outlined,
                      label: 'Email Alerts',
                      value: _emailAlerts,
                      onChanged: (v) =>
                          setState(() => _emailAlerts = v),
                    ),
                    _SToggle(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'Message Notifications',
                      value: _messageNotifications,
                      onChanged: (v) =>
                          setState(() => _messageNotifications = v),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SGroup(
                  title: 'Preferences',
                  children: [
                    _SToggle(
                      icon: Icons.dark_mode_outlined,
                      label: 'Dark Mode',
                      value: _darkMode,
                      onChanged: (v) => setState(() => _darkMode = v),
                    ),
                    _SDropdown(
                      icon: Icons.currency_pound_outlined,
                      label: 'Currency',
                      value: _currency,
                      items: const ['GBP', 'EUR', 'USD'],
                      onChanged: (v) =>
                          setState(() => _currency = v ?? 'GBP'),
                    ),
                    _SDropdown(
                      icon: Icons.language_outlined,
                      label: 'Language',
                      value: _language,
                      items: const ['English', 'French', 'Spanish', 'Italian'],
                      onChanged: (v) =>
                          setState(() => _language = v ?? 'English'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SGroup(
                  children: [
                    _STile(
                      icon: Icons.shield_outlined,
                      label: 'Privacy Policy',
                      onTap: () {},
                    ),
                    _STile(
                      icon: Icons.description_outlined,
                      label: 'Terms of Service',
                      onTap: () {},
                    ),
                    _STile(
                      icon: Icons.info_outline_rounded,
                      label: 'App Version',
                      trailing: const Text(
                        'v1.0.0',
                        style: TextStyle(
                            color: YwcTheme.text3,
                            fontSize: 13),
                      ),
                      onTap: null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SGroup(
                  children: [
                    _STile(
                      icon: Icons.logout_rounded,
                      label: 'Sign Out',
                      labelColor: YwcTheme.red,
                      iconColor: YwcTheme.red,
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (_) => false,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [YwcTheme.navy, YwcTheme.navyLight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white),
              ),
              Text(
                'Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: color),
        ),
      );
}

class _SGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SGroup({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: YwcTheme.text3,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: YwcTheme.surface2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: YwcTheme.borderColor),
          ),
          child: Column(
            children: children.asMap().entries.map((e) {
              final isLast = e.key == children.length - 1;
              return Column(
                children: [
                  e.value,
                  if (!isLast)
                    const Divider(
                        height: 1, indent: 52, color: YwcTheme.borderColor),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _STile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final Color? labelColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _STile({
    required this.icon,
    required this.label,
    this.trailing,
    this.labelColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? YwcTheme.text2),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: labelColor ?? YwcTheme.text1,
                ),
              ),
            ),
            trailing ??
                (onTap != null
                    ? const Icon(Icons.chevron_right_rounded,
                        size: 18, color: YwcTheme.text3)
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}

class _SToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SToggle({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: YwcTheme.text2),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: YwcTheme.text1),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: YwcTheme.teal,
          ),
        ],
      ),
    );
  }
}

class _SDropdown extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _SDropdown({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: YwcTheme.text2),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: YwcTheme.text1),
            ),
          ),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            style: const TextStyle(
                color: YwcTheme.text2,
                fontSize: 13,
                fontWeight: FontWeight.w600),
            items: items
                .map((i) =>
                    DropdownMenuItem(value: i, child: Text(i)))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}