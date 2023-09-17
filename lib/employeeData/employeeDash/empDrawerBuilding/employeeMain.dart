import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../empDrawerPages/empProfilePage/profilepage.dart';
import '../empDrawerPages/EmpReports/reports_page_employee.dart';
import '../empDrawerPages/empLogout/homepage.dart';
import '../employee_Dashboard_Bloc/EmpDashboardk_bloc.dart';
import 'empDash/empDashHome.dart';
import 'empDrawer.dart';
import 'empDrawerItems.dart';

class EmpMainPage extends StatefulWidget {
  const EmpMainPage({Key? key}) : super(key: key);

  @override
  State<EmpMainPage> createState() => _EmpMainPageState();
}

class _EmpMainPageState extends State<EmpMainPage> {
  final EmpDashboardkBloc dashBloc = EmpDashboardkBloc();

  late double xoffset;
  late double yoffset;
  late double scaleFactor;
  bool isDragging = false;
  bool isDrawerOpen = false;
  EmpDrawerItem item = EmpDrawerItems.home;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  void openDrawer() {
    setState(() {
      xoffset = 230;
      yoffset = 170;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xoffset = 0;
      yoffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(

    body: Stack(
      children: [
        buildDrawer(),
        buildPage(),
      ],
    ),
  );

  Widget buildDrawer() => SafeArea(
    child: AnimatedOpacity(
      opacity: isDrawerOpen ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        width: xoffset,
        child: MyDrawer(
          onSelectedItems: (selectedItem) {
            setState(() {
              item = selectedItem;
              closeDrawer();
            });

            switch (item) {
              case EmpDrawerItems.home:
                dashBloc.add(NavigateToHomeEvent());
                break;
              case EmpDrawerItems.reports:
                dashBloc.add(NavigateToReportsEvent());
                break;

              case EmpDrawerItems.profile:
                dashBloc.add(NavigateToProfileEvent());
                break;

              case EmpDrawerItems.logout:
                dashBloc.add(NavigateToLogoutEvent());
                break;

              default:
                dashBloc.add(NavigateToHomeEvent());
                break;
            }
          },
        ),
      ),
    ),
  );

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          const delta = 1;

          if (!isDragging) return;

          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.translationValues(xoffset, yoffset, 0)
            ..scale(scaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
              child: Container(
                color: isDrawerOpen
                    ? Colors.white12.withOpacity(0.23)
                    : const Color(0xFFFDF7F5),
                child: getDrawerPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerPage() {
    return BlocBuilder<EmpDashboardkBloc, EmpDashboardkState>(
      bloc: dashBloc,
      builder: (context, state) {
        if (state is NavigateToProfileState) {
          return EmpProfilePage(openDrawer: openDrawer);
        } else if (state is NavigateToHomeState) {
          return EmpDashboard(openDrawer: openDrawer);
        }
        else if (state is NavigateToReportsState) {
          return EmpReportsPage(
            openDrawer: openDrawer,
          );
        }
        else if (state is NavigateToLogoutState) {
          return EmpHomePage();
        }
        else {
          return EmpDashboard(openDrawer: openDrawer);
        }
      },
    );
  }
}
