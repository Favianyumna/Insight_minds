import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_providers.dart';
import '../../data/local/habit_entry.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../risk_analysis/data/llm_service.dart';
import '../../../../shared/widgets/ai_bot_button.dart';

class HabitPage extends ConsumerWidget {
  const HabitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          const AiBotButton(),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Habit',
            onPressed: () => _showAddHabitDialog(context, ref),
          ),
        ],
      ),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.refresh(habitListProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (habits) {
          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada habit',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan habit baru untuk memulai tracking',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => _showAddHabitDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Habit'),
                  ),
                ],
              ),
            );
          }

          final today = DateTime.now();
          final todayOnly = DateTime(today.year, today.month, today.day);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ringkasan Hari Ini',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${habits.where((h) => h.isCompletedOn(todayOnly)).length} dari ${habits.length} habit selesai',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Habit list
              ...habits.map((habit) => _HabitCard(
                    key: ValueKey(habit.id),
                    habit: habit,
                    onToggle: () async {
                      final today = DateTime.now();
                      try {
                        await ref
                            .read(habitRepositoryProvider)
                            .toggleCompletion(habit.id, today);
                        // ignore: unused_result
                        ref.refresh(habitListProvider);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    onDelete: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Hapus Habit'),
                          content: Text(
                              'Yakin ingin menghapus habit "${habit.title}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Batal'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        try {
                          await ref
                              .read(habitRepositoryProvider)
                              .delete(habit.id);
                          // ignore: unused_result
                          ref.refresh(habitListProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Habit berhasil dihapus')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      }
                    },
                  )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    TimeOfDay? reminderTime;
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tambah Habit Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Nama Habit',
                    hintText: 'Contoh: Olahraga pagi, Minum air 8 gelas',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip: 'Tanyakan Asisten',
                      icon: const Icon(Icons.smart_toy_outlined),
                      onPressed: () async {
                        // Use assistant to parse the command and optionally create a habit
                        final input = controller.text.trim();
                        if (input.isEmpty) {
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(content: Text('Isi nama atau perintah terlebih dahulu')),
                            );
                          }
                          return;
                        }

                        // determine settings
                        final settings = ref.read(settingsProvider);
                        final useExternal = settings.assistantUseExternalLLM && (settings.assistantApiKey?.isNotEmpty ?? false);

                        String rawReply = '';
                        try {
                          if (useExternal) {
                            final svc = LlmService(apiKey: settings.assistantApiKey!);
                            const systemPrompt = 'Anda adalah parser yang mengekstrak instruksi pembuatan habit. ' 
                                'Berikan RESPON dalam format JSON saja, contoh: {"action":"create_habit","title":"Minum air 8 gelas","notes":"pagi"} ' 
                                'Jika tidak ada perintah pembuatan habit, respon: {"action":"none"}';
                            rawReply = await svc.chatCompletion(input, systemPrompt: systemPrompt, maxTokens: 200);
                          } else {
                            // Simple heuristic fallback: always create a habit using raw text
                            rawReply = jsonEncode({'action': 'create_habit', 'title': input});
                          }
                        } catch (e) {
                          rawReply = jsonEncode({'action': 'none'});
                        }

                        // Try to parse JSON from assistant
                        try {
                          final parsed = jsonDecode(rawReply);
                          final action = parsed['action'] as String? ?? 'none';
                          if (action == 'create_habit') {
                            final title = (parsed['title'] as String?)?.trim() ?? input;
                            // create habit
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (context.mounted) Navigator.of(context).pop();
                            });
                            ref.read(isSavingHabitProvider.notifier).state = true;
                            try {
                              await ref.read(habitRepositoryProvider).add(title: title);
                              // ignore: unused_result
                              ref.refresh(habitListProvider);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Habit berhasil ditambahkan oleh Asisten')),
                                  );
                                }
                              });
                            } catch (e) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              });
                            } finally {
                              ref.read(isSavingHabitProvider.notifier).state = false;
                            }
                            return;
                          } else {
                            // show assistant reply if no action
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: ctx,
                                builder: (dCtx) => AlertDialog(
                                  title: const Text('Asisten mengatakan'),
                                  content: Text(rawReply),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Tutup')),
                                  ],
                                ),
                              );
                            });
                            return;
                          }
                        } catch (_) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Asisten tidak mengerti perintah')),
                              );
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Atur Pengingat (Opsional)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: reminderTime ?? TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        reminderTime = time;
                      });
                    }
                  },
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    reminderTime != null
                        ? 'Pengingat: ${reminderTime!.format(context)}'
                        : 'Pilih Waktu Pengingat',
                  ),
                ),
                if (reminderTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          reminderTime = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Hapus Pengingat'),
                    ),
                  ),
              ],
            ),
            ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                final title = controller.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                        content: Text('Nama habit tidak boleh kosong')),
                  );
                  return;
                }
                Navigator.pop(ctx);
                ref.read(isSavingHabitProvider.notifier).state = true;
                try {
                  await ref.read(habitRepositoryProvider).add(title: title);
                  
                  // Setup reminder notification if reminder time is set
                  if (reminderTime != null) {
                    final notificationService = ref.read(notificationServiceProvider);
                    final hour = reminderTime!.hour;
                    final minute = reminderTime!.minute;
                    
                    // Schedule daily notification for this habit
                    await notificationService.scheduleDaily(
                      id: title.hashCode,
                      title: 'Pengingat Habit',
                      body: 'Saatnya melakukan: $title',
                      hour: hour,
                      minute: minute,
                    );
                  }
                  
                  // ignore: unused_result
                  ref.refresh(habitListProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(reminderTime != null
                            ? 'Habit berhasil ditambahkan dengan pengingat pukul ${reminderTime!.format(context)}'
                            : 'Habit berhasil ditambahkan'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } finally {
                  ref.read(isSavingHabitProvider.notifier).state = false;
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final HabitEntry habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final isCompleted = habit.isCompletedOn(todayOnly);
    final streak = habit.getCurrentStreak();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: isCompleted,
          onChanged: (_) => onToggle(),
          shape: const CircleBorder(),
        ),
        title: Text(
          habit.title,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: streak > 0
            ? Text(
                '🔥 Streak: $streak hari',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
          tooltip: 'Hapus habit',
        ),
        onTap: onToggle,
      ),
    );
  }
}
