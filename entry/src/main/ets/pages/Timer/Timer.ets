import TimerConstants from '../../common/constants/TimerConstants';
import { TimerService } from '../../viewmodel/TimerService';

export const TIMER_PAGE = 'TimerPage';

@Builder
export function TimerPageBuilder() {
  Timer();
}

export class TimerPageParam {
  fastDuration: number;
  slowDuration: number;
  repetitions: number;

  constructor(fastDuration: number, slowDuration: number, repetitions: number) {
    this.fastDuration = fastDuration;
    this.slowDuration = slowDuration;
    this.repetitions = repetitions;
  }
}

@Component
export struct Timer {
  @Consume('NavPathStack') private pageStack: NavPathStack;
  private textTimerController: TextTimerController = new TextTimerController();
  private timerService: TimerService = new TimerService();
  @State params: TimerPageParam = new TimerPageParam(0, 0, 0);
  @State fastDuration: number = 10;
  @State slowDuration: number = 5;
  @State repetitions: number = 2;
  @State repetitionsRemain: number = 3;
  @State timerSec: number = 10;
  @State remainderMs: number = TimerConstants.INIT_COUNTDOWN_SEC * TimerConstants.SEC_TO_MS;
  @State currentTimerCount: number = TimerConstants.INIT_COUNTDOWN_SEC * TimerConstants.SEC_TO_MS;
  @State currentGradient: LinearGradient = TimerConstants.INIT_COUNTDOWN_GD;
  @State isSlowDuration: boolean = false;
  @State currentActivity: string = 'to Start!';
  @State currentRepetition: number = 0;
  @State currentRoundDisplay: number = 0; //  UI'de gösterilecek round sayısı

  aboutToAppear(): void {
    this.loadParameters();
    this.resetTimer();
    setTimeout((): void => this.startInitialCountdown(), TimerConstants.INIT_DELAY);
  }

  aboutToDisappear(): void {
    this.timerService.clear();
  }

  private loadParameters(): void {
    if (this.params) {
      this.fastDuration = this.params.fastDuration;
      this.slowDuration = this.params.slowDuration;
      this.repetitions = this.params.repetitions;
      this.repetitionsRemain = this.repetitions;
    }
  }

  private resetTimer(): void {
    this.remainderMs = TimerConstants.INIT_COUNTDOWN_SEC * TimerConstants.SEC_TO_MS;
    this.currentTimerCount = this.remainderMs;
  }

  private startInitialCountdown(): void {
    this.currentActivity = 'to Start!';
    this.currentGradient = TimerConstants.INIT_COUNTDOWN_GD;

    this.textTimerController.reset();
    this.timerSec = TimerConstants.INIT_COUNTDOWN_SEC;
    this.currentTimerCount = this.timerSec * TimerConstants.SEC_TO_MS;

    setTimeout((): void => this.textTimerController.start(), TimerConstants.DELAY_50);

    this.timerService.start(this.timerSec,
      (remaining) => {
        this.remainderMs = remaining;
      },
      (): void => this.startActivity());
  }

  private startActivity(): void {
    this.isSlowDuration = false;
    this.currentGradient = TimerConstants.FAST_DURATION_GD;
    this.currentActivity = 'Fast';

    this.startTimer(this.fastDuration, false);
  }

  private startTimer(seconds: number, isSlowDuration: boolean): void {
    this.timerService.clear();

    this.timerSec = seconds;
    this.remainderMs = seconds * TimerConstants.SEC_TO_MS;
    this.currentTimerCount = this.remainderMs;
    this.isSlowDuration = isSlowDuration;
    this.currentGradient = isSlowDuration ? TimerConstants.SLOW_DURATION_GD : TimerConstants.FAST_DURATION_GD;
    this.currentActivity = isSlowDuration ? 'Slow' : 'Fast';

    //  UI'de gösterilecek round sayısını her turda güncelle
    this.currentRoundDisplay = this.currentRepetition + 1;

    this.textTimerController.reset();
    setTimeout((): void => this.textTimerController.start(), TimerConstants.DELAY_50);

    this.timerService.start(seconds,
      (remaining) => {
        this.remainderMs = remaining;
      },
      () => this.handleTimerCompletion(isSlowDuration));
  }

  private handleTimerCompletion(isSlowDuration: boolean): void {
    if (isSlowDuration) {
      this.currentRepetition++;
      this.repetitionsRemain--;

      if (this.repetitionsRemain > 0) {
        setTimeout((): void => this.startTimer(this.fastDuration, false), TimerConstants.DELAY);
      } else {
        this.onCompleteAllTimers();
      }
    } else {
      // Fast tamamlandı, sırada slow var
      setTimeout((): void => this.startTimer(this.slowDuration, true), TimerConstants.DELAY);
    }
  }

  private onCompleteAllTimers(): void {
    this.currentActivity = 'Complete!';
  }

  build() {
    NavDestination() {
      Column() {
        Stack() {
          Progress({
            value: this.remainderMs,
            total: this.timerSec * TimerConstants.SEC_TO_MS,
            type: ProgressType.Ring
          })
            .width('100%')
            .color(this.currentGradient)
            .style({ strokeWidth: 20, enableScanEffect: true })

          Column() {
            TextTimer({
              isCountDown: true,
              count: this.currentTimerCount,
              controller: this.textTimerController
            })
              .format(TimerConstants.TIME_FORMAT)
              .fontColor(Color.White)
              .fontSize(50)
              .fontWeight(700)

            //  Her fast & slow ekranında Round x/y yazısı gösterilir
            Text(this.currentActivity + ' - Round ' + this.currentRoundDisplay + '/' + this.repetitions)
              .fontSize(10)
          }
        }
      }
      .height('100%')
      .width('100%')
      .padding(10)
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}
