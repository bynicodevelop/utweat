import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utweat/config/constants.dart';
import 'package:utweat/respositories/abstracts/database_repository.dart';
import 'package:utweat/respositories/content_repository.dart';
import 'package:utweat/respositories/sqlite_repository.dart';
import 'package:utweat/screens/home_screen.dart';
import 'package:utweat/services/add_content/add_content_bloc.dart';
import 'package:utweat/services/delete_content/delete_content_bloc.dart';
import 'package:utweat/services/generate_content/generate_content_bloc.dart';
import 'package:utweat/services/list_content/list_content_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseRepository databaseRepository = SQLiteRepository();

  await databaseRepository.intializeDatabase("tweat_database.db");

  runApp(App(
    databaseRepository: databaseRepository,
  ));
}

class App extends StatelessWidget {
  final DatabaseRepository databaseRepository;

  const App({
    Key? key,
    required this.databaseRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContentRepository contentRepository = ContentRepository(
      databaseRepository,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => ListContentBloc(
            contentRepository: contentRepository,
          )..add(OnLoadedContentEvent()),
        ),
        BlocProvider(
          create: (context) => AddContentBloc(
            contentRepository: contentRepository,
          ),
        ),
        BlocProvider(
          create: (context) => DeleteContentBloc(
            contentRepository: contentRepository,
          ),
        ),
        BlocProvider(
          create: (context) => GenerateContentBloc(
            contentRepository: contentRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'UTweat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: kPrimaryMaterialColor,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: kPrimaryMaterialColor,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
