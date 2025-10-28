import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Account',
            [
              _buildMenuItem(
                context,
                Icons.person,
                'Personal Information',
                'Edit your profile details',
                () {},
              ),
              _buildMenuItem(
                context,
                Icons.fitness_center,
                'Fitness Goals',
                'Set your fitness targets',
                () {},
              ),
              _buildMenuItem(
                context,
                Icons.notifications,
                'Notifications',
                'Manage notification preferences',
                () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'App Settings',
            [
              _buildMenuItem(
                context,
                Icons.dark_mode,
                'Theme',
                'Light, Dark, or System',
                () {},
              ),
              _buildMenuItem(
                context,
                Icons.language,
                'Language',
                'English',
                () {},
              ),
              _buildMenuItem(
                context,
                Icons.scale,
                'Units',
                'Metric (kg, cm)',
                () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'Subscription',
            [
              _buildMenuItem(
                context,
                Icons.star,
                'Upgrade to Pro',
                'Unlock all features',
                () => _showSubscriptionDialog(context),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'FREE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _buildMenuItem(
                context,
                Icons.restore,
                'Restore Purchases',
                'Restore previous subscriptions',
                () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'Support',
            [
              _buildMenuItem(
                context,
                Icons.help,
                'Help & Support',
                'Get help with the app',
                () {},
              ),
              _buildMenuItem(
                context,
                Icons.feedback,
                'Send Feedback',
                'Share your thoughts',
                () {},
              ),
              _buildMenuItem(
                context,
                Icons.privacy_tip,
                'Privacy Policy',
                'Read our privacy policy',
                () {},
              ),
              _buildMenuItem(
                context,
                Icons.description,
                'Terms of Service',
                'Read our terms',
                () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'About',
            [
              _buildMenuItem(
                context,
                Icons.info,
                'App Version',
                '1.0.0',
                null,
              ),
            ],
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.red),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 50,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Guest User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Free Plan',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Pro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unlock premium features:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem('Unlimited workout tracking'),
            _buildFeatureItem('Advanced analytics'),
            _buildFeatureItem('Custom workout plans'),
            _buildFeatureItem('Progress photos'),
            _buildFeatureItem('Nutrition tracking'),
            _buildFeatureItem('Priority support'),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildPricingOption('Basic', r'$5/month', 'Essential features'),
            const SizedBox(height: 8),
            _buildPricingOption('Pro', r'$15/month', 'All features + AI coaching', isPopular: true),
            const SizedBox(height: 8),
            _buildPricingOption('Elite', r'$25/month', 'Pro + personal trainer access'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle subscription
            },
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildPricingOption(String name, String price, String description, {bool isPopular = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isPopular ? Colors.amber : Colors.grey[300]!,
          width: isPopular ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isPopular ? Colors.amber.withOpacity(0.1) : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (isPopular) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'POPULAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
