import TimerConstants from '../common/constants/TimerConstants';

export class TimerService {
  private intervalID: number = 0;
  private startTime: number = 0;

  start(durationSec: number, onTick: (remainingMs: number) => void, onEnd: () => void): void {
    this.clear();
    const durationMs = durationSec * TimerConstants.SEC_TO_MS;
    this.startTime = Date.now();

    onTick(durationMs);

    this.intervalID = setInterval(() => {
      const elapsedMs = Date.now() - this.startTime;
      const remaining = Math.max(0, durationMs - elapsedMs);
      onTick(remaining);

      if (remaining <= 0) {
        this.clear();
        onEnd();
      }
    }, TimerConstants.FPS_60);
  }

  clear(): void {
    if (this.intervalID !== 0) {
      clearInterval(this.intervalID);
      this.intervalID = 0;
    }
  }
}