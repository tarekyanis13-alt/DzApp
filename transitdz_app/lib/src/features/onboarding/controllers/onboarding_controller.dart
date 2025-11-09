import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingCompletedProvider =
    StateNotifierProvider<OnboardingController, bool>((ref) {
  return OnboardingController();
});

class OnboardingController extends StateNotifier<bool> {
  OnboardingController() : super(false);

  void complete() => state = true;
}
