
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/dashboard_models.dart';
import '../../../data/dashboard_repository.dart';

class DashboardState {
  const DashboardState({
    required this.profile,
    required this.banner,
    required this.navigationItems,
    required this.bottomActions,
    required this.workspaces,
    required this.officeHours,
    required this.projects,
    required this.creators,
    required this.performance,
    required this.events,
    required this.selectedSection,
    required this.isWorkspaceExpanded,
    required this.focusedCalendarDay,
    required this.selectedCalendarDay,
    required this.selectedProjectId,
  });

  final DashboardProfile profile;
  final BannerContent banner;
  final List<NavItem> navigationItems;
  final List<NavItem> bottomActions;
  final List<WorkspaceItem> workspaces;
  final OfficeHours officeHours;
  final List<Project> projects;
  final List<Creator> creators;
  final List<PerformanceData> performance;
  final List<OfficeEvent> events;
  final String selectedSection;
  final bool isWorkspaceExpanded;
  final DateTime focusedCalendarDay;
  final DateTime selectedCalendarDay;
  final String? selectedProjectId;

  DashboardState copyWith({
    DashboardProfile? profile,
    BannerContent? banner,
    List<NavItem>? navigationItems,
    List<NavItem>? bottomActions,
    List<WorkspaceItem>? workspaces,
    OfficeHours? officeHours,
    List<Project>? projects,
    List<Creator>? creators,
    List<PerformanceData>? performance,
    List<OfficeEvent>? events,
    String? selectedSection,
    bool? isWorkspaceExpanded,
    DateTime? focusedCalendarDay,
    DateTime? selectedCalendarDay,
    String? selectedProjectId,
  }) {
    return DashboardState(
      profile: profile ?? this.profile,
      banner: banner ?? this.banner,
      navigationItems: navigationItems ?? this.navigationItems,
      bottomActions: bottomActions ?? this.bottomActions,
      workspaces: workspaces ?? this.workspaces,
      officeHours: officeHours ?? this.officeHours,
      projects: projects ?? this.projects,
      creators: creators ?? this.creators,
      performance: performance ?? this.performance,
      events: events ?? this.events,
      selectedSection: selectedSection ?? this.selectedSection,
      isWorkspaceExpanded: isWorkspaceExpanded ?? this.isWorkspaceExpanded,
      focusedCalendarDay: focusedCalendarDay ?? this.focusedCalendarDay,
      selectedCalendarDay: selectedCalendarDay ?? this.selectedCalendarDay,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
    );
  }
}

class DashboardController extends Notifier<DashboardState> {
  final DashboardRepository _repository = const DashboardRepository();

  @override
  DashboardState build() {
    final projects = _repository.projects();
    return DashboardState(
      profile: _repository.profile(),
      banner: _repository.banner(),
      navigationItems: _repository.navigationItems(),
      bottomActions: _repository.bottomActions(),
      workspaces: _repository.workspaces(),
      officeHours: _repository.officeHours(),
      projects: projects,
      creators: _repository.creators(),
      performance: _repository.performance(),
      events: _repository.events(),
      selectedSection: 'Home',
      isWorkspaceExpanded: true,
      focusedCalendarDay: DateTime(2023, 10),
      selectedCalendarDay: DateTime(2023, 10, 10),
      selectedProjectId: projects.isNotEmpty ? projects.first.id : null,
    );
  }

  // ── Navigation ──
  void selectSection(String section) {
    state = state.copyWith(selectedSection: section);
  }

  void toggleWorkspace() {
    state = state.copyWith(isWorkspaceExpanded: !state.isWorkspaceExpanded);
  }

  void selectCalendarDay(DateTime selectedDay, DateTime focusedDay) {
    state = state.copyWith(
      selectedCalendarDay: selectedDay,
      focusedCalendarDay: focusedDay,
    );
  }

  // ── Profile ──
  void updateProfile({required String name, required String role}) {
    state = state.copyWith(
      profile: DashboardProfile(
        name: name,
        role: role,
        avatarEmoji: state.profile.avatarEmoji,
      ),
    );
  }

  // ── Banner ──
  void updateBanner({
    required String kicker,
    required String title,
    required String description,
  }) {
    state = state.copyWith(
      banner: BannerContent(
        kicker: kicker,
        title: title,
        description: description,
        actionLabel: state.banner.actionLabel,
      ),
    );
  }

  // ── Projects CRUD ──
  void addProject(Project project) {
    state = state.copyWith(projects: [...state.projects, project]);
  }

  void updateProject(Project updated) {
    state = state.copyWith(
      projects: state.projects
          .map((p) => p.id == updated.id ? updated : p)
          .toList(),
    );
  }

  void deleteProject(String id) {
    final updated = state.projects.where((p) => p.id != id).toList();
    final newSelectedId = state.selectedProjectId == id
        ? (updated.isNotEmpty ? updated.first.id : null)
        : state.selectedProjectId;
    state = state.copyWith(projects: updated, selectedProjectId: newSelectedId);
  }

  void selectProject(String id) {
    state = state.copyWith(selectedProjectId: id);
  }

  // ── Creators CRUD ──
  void addCreator(Creator creator) {
    state = state.copyWith(creators: [...state.creators, creator]);
  }

  void updateCreator(Creator updated) {
    state = state.copyWith(
      creators: state.creators
          .map((c) => c.id == updated.id ? updated : c)
          .toList(),
    );
  }

  void deleteCreator(String id) {
    state = state.copyWith(
      creators: state.creators.where((c) => c.id != id).toList(),
    );
  }

  // ── Events CRUD ──
  void addEvent(OfficeEvent event) {
    state = state.copyWith(events: [...state.events, event]);
  }

  void deleteEvent(String id) {
    state = state.copyWith(
      events: state.events.where((e) => e.id != id).toList(),
    );
  }

  // ── Workspaces CRUD ──
  void addWorkspace(String label) {
    state = state.copyWith(
      workspaces: [...state.workspaces, WorkspaceItem(label: label)],
    );
  }

  void renameWorkspace(int index, String newLabel) {
    final updated = [...state.workspaces];
    updated[index] = WorkspaceItem(label: newLabel);
    state = state.copyWith(workspaces: updated);
  }

  void deleteWorkspace(int index) {
    final updated = [...state.workspaces];
    updated.removeAt(index);
    state = state.copyWith(workspaces: updated);
  }

  // ── Performance CRUD ──
  void addPerformanceData(PerformanceData data) {
    final updated = [...state.performance, data];
    updated.sort((a, b) => a.year.compareTo(b.year));
    state = state.copyWith(performance: updated);
  }

  void deletePerformanceData(int year) {
    state = state.copyWith(
      performance: state.performance.where((p) => p.year != year).toList(),
    );
  }
}

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) {
    state = value;
  }

  void clear() {
    state = '';
  }
}

final dashboardProvider = NotifierProvider<DashboardController, DashboardState>(
  DashboardController.new,
);

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

final filteredProjectsProvider = Provider<List<Project>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final projects = ref.watch(dashboardProvider.select((s) => s.projects));
  if (query.isEmpty) return projects;

  return projects.where((project) {
    final searchable = '${project.title} ${project.description}'.toLowerCase();
    return searchable.contains(query);
  }).toList();
});

final filteredCreatorsProvider = Provider<List<Creator>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final creators = ref.watch(dashboardProvider.select((s) => s.creators));
  if (query.isEmpty) return creators;

  return creators.where((creator) {
    final searchable = creator.handle.toLowerCase();
    return searchable.contains(query);
  }).toList();
});

final birthdayEventsProvider = Provider<List<OfficeEvent>>((ref) {
  return ref
      .watch(dashboardProvider.select((s) => s.events))
      .where((event) => event.type == EventType.birthday)
      .toList();
});

final anniversaryEventsProvider = Provider<List<OfficeEvent>>((ref) {
  return ref
      .watch(dashboardProvider.select((s) => s.events))
      .where((event) => event.type == EventType.anniversary)
      .toList();
});
