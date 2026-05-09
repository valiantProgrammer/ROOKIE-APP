import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? data;
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _fetchReports();
  }

  // 🔥 MAIN DATA
  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 400));

    data = {
      "battery": 78,
      "health": 86,
      "temperature": 34,
      "cpu": 28,
      "ram": 61,
      "fps": 29,
      "latency": 24,
      "usage": [
        {"title": "Live", "value": 45, "color": Colors.blue},
        {"title": "Playback", "value": 25, "color": Colors.purple},
        {"title": "Recording", "value": 15, "color": Colors.orange},
        {"title": "Other", "value": 15, "color": Colors.green},
      ],
      "graph": [100, 95, 90, 85, 80, 75, 70, 65],
    };

    setState(() {});
  }

  // 🔥 DUMMY REPORT FETCH
  Future<void> _fetchReports() async {
    await Future.delayed(const Duration(milliseconds: 400));

    reports = [
      {
        "title": "Weekly System Report",
        "date": "May 12 - May 18",
        "status": "Normal",
      },
      {
        "title": "Battery Analysis",
        "date": "Last 24 Hours",
        "status": "Stable",
      },
      {"title": "Performance Logs", "date": "Today", "status": "Optimized"},
    ];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ✅ THEME DETECTION
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF05080F) : Colors.grey[100];
    final primaryText = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.white54 : Colors.black54;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            _header(primaryText, iconColor),
            const SizedBox(height: 12),

            _card(_system(isDark, primaryText, secondaryText)),
            const SizedBox(height: 12),

            _card(_battery(isDark, primaryText, secondaryText)),
            const SizedBox(height: 12),

            _card(_performance(isDark, primaryText)),
            const SizedBox(height: 12),

            _card(_usage(isDark, primaryText, secondaryText)),
            const SizedBox(height: 12),

            _card(_reports(isDark, primaryText, secondaryText)),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _header(Color primaryText, Color iconColor) {
    return Row(
      children: [
        Icon(Icons.arrow_back, color: iconColor),
        Expanded(
          child: Text(
            "Analysis",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: primaryText),
          ),
        ),
        Icon(Icons.calendar_month, color: iconColor),
      ],
    );
  }

  // ---------------- SYSTEM ----------------
  Widget _system(bool isDark, Color primaryText, Color secondaryText) {
    return Row(
      children: [
        SizedBox(
          height: 130,
          width: 130,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 🔵 Background ring
              Positioned.fill(
                child: CustomPaint(
                  painter: _GradientRingPainter(
                    progress: data!["health"] / 100,
                    isDark: isDark,
                  ),
                ),
              ),
              IgnorePointer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${data!["health"]}%",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                    Text(
                      "Optimal",
                      style: TextStyle(fontSize: 10, color: secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _iconStat(
                Icons.battery_full,
                "78%",
                "Battery",
                Colors.green,
                primaryText,
                secondaryText,
              ),
              _iconStat(
                Icons.thermostat,
                "34°C",
                "Temp",
                Colors.purple,
                primaryText,
                secondaryText,
              ),
              _iconStat(
                Icons.access_time,
                "2d",
                "Uptime",
                Colors.blue,
                primaryText,
                secondaryText,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _iconStat(
    IconData icon,
    String value,
    String label,
    Color color,
    Color primaryText,
    Color secondaryText,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: secondaryText)),
      ],
    );
  }

  // ---------------- BATTERY GRAPH ----------------
  Widget _battery(bool isDark, Color primaryText, Color secondaryText) {
    final graphColor = isDark ? Colors.greenAccent : Colors.green;
    final gridColor = isDark ? Colors.white30 : Colors.black26;
    final textColor = isDark ? Colors.white70 : Colors.black54;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Battery Performance", style: TextStyle(color: primaryText)),
        const SizedBox(height: 12),
        Row(
          children: [
            // Graph left
            Expanded(
              child: SizedBox(
                height: 180,
                width: 300,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 100,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,

                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: isDark
                            ? const Color(0xFF111827) // dark card
                            : Colors.white,

                        tooltipRoundedRadius: 10,
                        tooltipPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),

                        fitInsideHorizontally: true,
                        fitInsideVertically: true,

                        // 🔥 FORCE TEXT STYLE (THIS IS THE REAL FIX)
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              "${spot.y.toStringAsFixed(1)}%",
                              TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : Colors.black, // 🔥 IMPORTANT
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            );
                          }).toList();
                        },
                      ),

                      // 🔥 ALSO FIX DOT STYLE (otherwise looks wrong in light mode)
                      getTouchedSpotIndicator:
                          (LineChartBarData barData, List<int> spotIndexes) {
                            return spotIndexes.map((index) {
                              return TouchedSpotIndicatorData(
                                FlLine(
                                  color: Colors.transparent,
                                ), // remove vertical line
                                FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, bar, index) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: bar.color ?? Colors.blue,
                                      strokeWidth: 2,
                                      strokeColor: isDark
                                          ? Colors.black
                                          : Colors.white,
                                    );
                                  },
                                ),
                              );
                            }).toList();
                          },
                    ),
                    // 🔥 GRID (fixed)
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true, // ✅ ENABLE vertical lines
                      horizontalInterval: 20,
                      verticalInterval: 1, // 🔥 important for vertical spacing

                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: gridColor.withOpacity(0.4),
                          strokeWidth: 1,
                        );
                      },

                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: gridColor.withOpacity(
                            0.25,
                          ), // slightly lighter
                          strokeWidth: 1,
                        );
                      },
                    ),

                    // 🔥 AXIS LABELS
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          getTitlesWidget: (v, _) => Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "${v.toInt()}:00",
                              style: TextStyle(color: textColor, fontSize: 10),
                            ),
                          ),
                        ),
                      ),

                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          getTitlesWidget: (v, _) => Text(
                            "${v.toInt()}",
                            style: TextStyle(color: textColor, fontSize: 10),
                          ),
                        ),
                      ),
                    ),

                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: gridColor.withOpacity(0.3)),
                    ),

                    // 🔥 CURVE SETTINGS
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          data!["graph"].length,
                          (i) => FlSpot(
                            i.toDouble(),
                            data!["graph"][i].toDouble(),
                          ),
                        ),

                        isCurved: true,
                        curveSmoothness: 0.4, // 🔥 smoother

                        barWidth: 3,
                        color: graphColor,

                        isStrokeCapRound: true,

                        dotData: FlDotData(show: false),

                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              graphColor.withOpacity(0.25),
                              graphColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Legend right
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _legend(
                  "Screen",
                  Colors.blue,
                  "40%",
                  primaryText,
                  secondaryText,
                ),
                _legend(
                  "Streaming",
                  Colors.purple,
                  "30%",
                  primaryText,
                  secondaryText,
                ),
                _legend(
                  "System",
                  Colors.orange,
                  "20%",
                  primaryText,
                  secondaryText,
                ),
                _legend(
                  "Others",
                  Colors.green,
                  "10%",
                  primaryText,
                  secondaryText,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _legend(
    String name,
    Color color,
    String val,
    Color primaryText,
    Color secondaryText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(width: 8, height: 8, color: color),
          const SizedBox(width: 6),
          Text(name, style: TextStyle(color: primaryText)),
          const SizedBox(width: 8),
          Text(val, style: TextStyle(color: secondaryText)),
        ],
      ),
    );
  }

  // ---------------- PERFORMANCE ----------------
  Widget _performance(bool isDark, Color primaryText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Performance Overview", style: TextStyle(color: primaryText)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _perf(
              "CPU Usage",
              Icons.memory,
              const Color.fromARGB(255, 5, 129, 218),
              "CPU",
              "28%",
              isDark,
            ),
            _perf(
              "RAM Usage",
              Icons.storage,
              Colors.purple,
              "RAM",
              "61%",
              isDark,
            ),
            _perf("FPS", Icons.speed, Colors.green, "FPS", "29fps", isDark),
            _perf(
              "WiFi Usage",
              Icons.wifi,
              Colors.red,
              "Network",
              "24ms",
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  List<FlSpot> _generateSpots() {
    final List<FlSpot> spots = [];
    double value = 5;

    for (int i = 0; i < 10; i++) {
      value += (i % 2 == 0 ? 1 : -1) * (1 + (i * 0.2));
      spots.add(FlSpot(i.toDouble(), value));
    }

    return spots;
  }

  Widget _miniGraph(Color baseColor, bool isDark) {
    final lineColor = isDark ? baseColor : baseColor.withValues(alpha: 0.8);

    final fillColor = isDark
        ? baseColor.withValues(alpha: 0.15)
        : baseColor.withValues(alpha: 0.08);

    final tooltipBg = isDark
        ? Colors.black.withValues(alpha: 0.8)
        : Colors.white;

    final tooltipText = isDark ? Colors.white : Colors.black;

    return SizedBox(
      height: 40,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 10,

          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),

          // 🔥 TOOLTIP CONTROL
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: tooltipBg,
              tooltipRoundedRadius: 8,
              fitInsideHorizontally: true,
              fitInsideVertically: true,

              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    spot.y.toStringAsFixed(2),
                    TextStyle(color: tooltipText, fontWeight: FontWeight.w600),
                  );
                }).toList();
              },
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: _generateSpots(),
              isCurved: true,
              curveSmoothness: 0.4,
              barWidth: 2.5,
              color: lineColor,
              dotData: FlDotData(show: false),

              belowBarData: BarAreaData(show: true, color: fillColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _perf(
    String legend,
    IconData icon,
    Color color,
    String title,
    String value,
    bool isDark,
  ) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: _cardBox(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          Text(
            legend,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.white54),
          ),

          const SizedBox(height: 8),

          // 🔥 MINI GRAPH
          _miniGraph(color, isDark),
        ],
      ),
    );
  }

  // ---------------- USAGE ----------------
  Widget _usage(bool isDark, Color primaryText, Color secondaryText) {
    return Row(
      children: [
        // Pie chart left
        SizedBox(
          height: 140,
          width: 140,
          child: PieChart(
            PieChartData(
              sections: data!["usage"].map<PieChartSectionData>((e) {
                return PieChartSectionData(
                  color: e["color"],
                  value: e["value"].toDouble(),
                  title: "",
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Legend right
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data!["usage"].map<Widget>((e) {
              return _legend(
                e["title"],
                e["color"],
                "${e["value"]}%",
                primaryText,
                secondaryText,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ---------------- REPORTS ----------------
  Widget _reports(bool isDark, Color primaryText, Color secondaryText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reports",
          style: TextStyle(
            color: primaryText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Column(
          children: reports.map((r) {
            final status = r["status"];

            // 🔥 Dynamic color based on status
            Color statusColor;
            if (status == "Normal" || status == "Optimized") {
              statusColor = Colors.green;
            } else if (status == "Stable") {
              statusColor = Colors.orange;
            } else {
              statusColor = Colors.red;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),

                // 🎨 Theme responsive background
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.white,

                // ✨ subtle glow / shadow
                boxShadow: [
                  if (!isDark) BoxShadow(color: Colors.black12, blurRadius: 8),
                ],

                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),

              child: Row(
                children: [
                  // 🔥 Colored indicator bar
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // 📄 Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r["title"],
                          style: TextStyle(
                            color: primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r["date"],
                          style: TextStyle(color: secondaryText, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // 🔥 Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------- UI HELPERS ----------------
  Widget _card(Widget child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardBox(isDark),
      child: child,
    );
  }

  BoxDecoration _cardBox(bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _GradientRingPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ringRadius = size.width / 2 - 8;

    // 🔵 Background ring
    final bgPaint = Paint()
      ..color = isDark ? Colors.white12 : Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 17;

    canvas.drawCircle(center, ringRadius, bgPaint);

    // 🌈 Gradient progress
    final rect = Rect.fromCircle(center: center, radius: ringRadius);

    final startAngle = 0 / 2;
    final sweepAngle = 2 * 3.14159 * progress;

    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: isDark
          ? [
              const Color(0xFF22C55E),
              const Color(0xFF06B6D4),
              const Color(0xFF22C55E),
            ]
          : [Colors.green, Colors.lightGreenAccent, Colors.green],
      stops: [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
