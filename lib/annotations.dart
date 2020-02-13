class StateStore {
  final bool hasSharedPrefs;

  const StateStore(this.hasSharedPrefs);
}

const SimpleStore = StateStore(false);
const SharedStore = StateStore(true);

class _SharedPreference {
  const _SharedPreference();
}

const Shared = _SharedPreference();
