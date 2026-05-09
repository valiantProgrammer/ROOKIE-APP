import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'register_face.dart';
import 'models/person_model.dart';
import 'person_detail_page.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  bool _showNav = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrollDirection = _scrollController.position.userScrollDirection;

    if (scrollDirection == ScrollDirection.reverse) {
      if (_showNav) setState(() => _showNav = false);
    } else if (scrollDirection == ScrollDirection.forward ||
        scrollDirection == ScrollDirection.idle) {
      if (!_showNav) setState(() => _showNav = true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToAddPerson() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPersonPage()),
    );
    // Rebuild the list when returning
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primary = theme.textTheme.bodyLarge!.color!;
    final secondary = theme.textTheme.bodyMedium!.color!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF05080F),
                    const Color(0xFF0A0F1C),
                    const Color(0xFF111827),
                  ]
                : [Colors.grey.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Registered People",
                            style: TextStyle(
                              color: primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Manage recognized users",
                            style: TextStyle(color: secondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: _glassBox(isDark),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: secondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                style: TextStyle(color: primary),
                                decoration: InputDecoration(
                                  hintText: "Search by name...",
                                  hintStyle: TextStyle(color: secondary),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: _glassBox(isDark),
                      child: Icon(Icons.tune, color: primary),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filter(
                        "All",
                        true,
                        Colors.deepPurple,
                        isDark,
                        secondary,
                      ),
                      _filter(
                        "Authorized",
                        false,
                        Colors.green,
                        isDark,
                        secondary,
                      ),
                      _filter(
                        "Pending",
                        false,
                        Colors.orange,
                        isDark,
                        secondary,
                      ),
                      _filter("Blocked", false, Colors.red, isDark, secondary),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // People list with scroll controller
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 80,
                    ),
                    itemCount: PersonService().getRegisteredPersons().length > 0
                        ? PersonService().getRegisteredPersons().length
                        : 1,
                    itemBuilder: (context, index) {
                      final registeredPersons = PersonService()
                          .getRegisteredPersons();

                      if (registeredPersons.isEmpty) {
                        // Show placeholder when no persons registered
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person_add,
                                  size: 48,
                                  color: secondary.withOpacity(0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "No registered people yet",
                                  style: TextStyle(
                                    color: secondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final person = registeredPersons[index];
                      return _person(person, isDark, primary, secondary);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ✅ BOTTOM NAVIGATION (ANIMATED)
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _showNav ? 65 : 0,
        child: Wrap(
          children: [
            Container(
              height: 65,
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.home),
                  Icon(Icons.videocam),
                  Icon(Icons.history),
                  Icon(Icons.person),
                ],
              ),
            ),
          ],
        ),
      ),

      // ✅ FAB THAT MOVES WITH BOTTOM NAV
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: AnimatedPadding(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.only(bottom: _showNav ? 80 : 20),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
            ),
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              _navigateToAddPerson();
            },
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ),
    );
  }

  // Adaptive glass box decoration
  BoxDecoration _glassBox(bool isDark) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
      ),
    );
  }

  // Filter chip (theme-aware)
  Widget _filter(
    String text,
    bool active,
    Color color,
    bool isDark,
    Color secondary,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: active
            ? LinearGradient(colors: [color, color.withValues(alpha: 0.7)])
            : null,
        color: active
            ? null
            : (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : secondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Person card (theme-aware)
  Widget _person(
    RegisteredPerson person,
    bool isDark,
    Color primary,
    Color secondary,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailPage(person: person),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
        decoration: _glassBox(isDark),
        child: Row(
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name,
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "ID: ${person.id}",
                    style: TextStyle(color: secondary, fontSize: 11),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 12,
                        color: secondary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Registered on ${person.registrationDate}",
                        style: TextStyle(
                          color: secondary.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    person.status,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Icon(Icons.chevron_right, color: secondary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
