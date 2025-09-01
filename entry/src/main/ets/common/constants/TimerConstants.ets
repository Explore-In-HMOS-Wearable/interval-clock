export default class TimerConstants {
  static readonly SEC_TO_MS: number = 1000;
  static readonly INIT_COUNTDOWN_SEC: number = 5;
  static INIT_BREAK_SEC: number = 10;
  static readonly FPS_60: number = 16;
  static readonly DELAY: number = 500;
  static readonly DELAY_50: number = 50;
  static readonly INIT_DELAY: number = 300;
  static readonly TIME_FORMAT: string = 'mm:ss';

  static readonly INIT_COUNTDOWN_GD: LinearGradient = new LinearGradient([
    { color: '#007DFF', offset: 0 },
    { color: '#00C3FF', offset: 1 }
  ]);

  static readonly FAST_DURATION_GD: LinearGradient = new LinearGradient([
    { color: '#FF7D00', offset: 0 },
    { color: '#FFC300', offset: 1 }
  ]);

  static readonly SLOW_DURATION_GD: LinearGradient = new LinearGradient([
    { color: '#00FF7D', offset: 0 },
    { color: '#00FFC3', offset: 1 }
  ]);
}