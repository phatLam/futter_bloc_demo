import 'package:demo2/timer/bloc/timer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ticker.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Timer"),
      ),
      body: const Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(child: TimerText()),
              ),
              Actions(),
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade50, Colors.blue.shade500])),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      "$minutesStr:$secondsStr",
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...switch (state) {
                TimerInitial() => [
                    FloatingActionButton(
                        onPressed: () => context
                            .read<TimerBloc>()
                            .add(TimerStarted(duration: state.duration)),
                        child: const Icon(Icons.play_arrow))
                  ],
                TimerRunPause() => [
                    FloatingActionButton(
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerResumed()),
                      child: const Icon(Icons.play_arrow),
                    ),
                    FloatingActionButton(
                      child: const Icon(Icons.replay),
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerReset()),
                    ),
                  ],
                TimerRunInProgress() => [
                    FloatingActionButton(
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerPaused()),
                      child: const Icon(Icons.pause),
                    ),
                    FloatingActionButton(
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerReset()),
                      child: const Icon(Icons.replay),
                    ),
                  ],
                TimerRunComplete() => [
                    FloatingActionButton(
                      child: const Icon(Icons.replay),
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerReset()),
                    ),
                  ],
              }
            ],
          );
        });
  }
}
