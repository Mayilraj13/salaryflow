import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rent_provider.dart';
import '../widgets/rent_status_card.dart';
import '../widgets/rent_history_card.dart';
import '../../../../core/constants/app_constants.dart';

class RentScreen extends ConsumerStatefulWidget {
  const RentScreen({super.key});

  @override
  ConsumerState<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends ConsumerState<RentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rentProvider.notifier).load();
    });
  }

  Future<void> _refresh() async {
    await ref.read(rentProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rentProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navRent),
      ),
      body: _buildBody(state, theme),
    );
  }

  Widget _buildBody(RentState state, ThemeData theme) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 12),
              Text(state.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          const SizedBox(height: 8),
          // Current month status
          const RentStatusCard(),
          const SizedBox(height: 8),
          // History
          RentHistoryCard(history: state.rentHistory),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
