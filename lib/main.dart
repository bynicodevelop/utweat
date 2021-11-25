import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utweat/respositories/content_repository.dart';
import 'package:utweat/screens/home_screen.dart';
import 'package:utweat/services/list_content/list_content_bloc.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContentRepository contentRepository = ContentRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ListContentBloc(
            contentRepository: contentRepository,
          ),
        )
      ],
      child: MaterialApp(
        title: 'UTweat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
