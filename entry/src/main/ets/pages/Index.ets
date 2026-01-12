import { INavParams } from '../common/interfaces/INavParams';
import { TimerPageBuilder, TimerPageParam, TIMER_PAGE } from './Timer/Timer';

@Entry
@Component
struct Index {
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()
  @State fastDuration: number = 30;
  @State slowDuration: number = 90;
  @State repetitions: number = 6;

  @Builder
  PagesMap(name: string) {
    if (name === TIMER_PAGE) {
      TimerPageBuilder();
    }
  }

  build() {
    Navigation(this.pageStack) {
      Scroll() {
        Column() {

          Row() {
            Text('Fast')
              .fontSize(18)
              .fontColor(Color.White)
              .width('30%')
              .textAlign(TextAlign.Start)
              .padding({ left: '9vp' })

            Row() {
              Button('-')
                .fontSize(18)
                .fontColor(Color.White)
                .backgroundColor('transparent')
                .onClick(() => {
                  if (this.fastDuration > 5) {
                    this.fastDuration -= 5;
                  }
                })

              Text(`${this.fastDuration}sec`)

                .fontSize(18)
                .fontColor(Color.White)
                .width(50)
                .textAlign(TextAlign.Center)

              Button('+')
                .fontSize(18)
                .fontColor(Color.White)
                .backgroundColor('transparent')
                .onClick(() => {
                  this.fastDuration += 5;
                })
            }
            .width('64%')
            .height(34)
            .borderRadius(22)
            .backgroundColor('#333333')
            .justifyContent(FlexAlign.SpaceEvenly)
          }
          .width('90%')
          .height(40)
          .margin({ bottom: 6, top: 3 })

          Row() {
            Text('Slow')
              .fontSize(18)
              .fontColor(Color.White)
              .width('30%')
              .textAlign(TextAlign.Start)
              .padding({ left: '9vp' })

            Row() {
              Button('-')
                .fontSize(18)
                .fontColor(Color.White)
                .backgroundColor('transparent')
                .onClick(() => {
                  if (this.slowDuration > 5) {
                    this.slowDuration -= 5;
                  }
                })

              Text(`${this.slowDuration}sec`)
                .fontSize(18)
                .fontColor(Color.White)
                .width(50)
                .textAlign(TextAlign.Center)

              Button('+')
                .fontSize(18)
                .fontColor(Color.White)
                .backgroundColor('transparent')
                .onClick(() => {
                  this.slowDuration += 5;
                })
            }
            .width('64%')
            .height(34)
            .borderRadius(22)
            .backgroundColor('#333333')
            .justifyContent(FlexAlign.SpaceEvenly)
          }
          .width('90%')
          .height(40)
          .margin({ bottom: 6 })

          // Repetition setting
          Row() {
            Text('Reps')
              .fontSize(18)
              .fontColor(Color.White)
              .width('30%')
              .textAlign(TextAlign.Start)
              .padding({ left: '9vp' })


            Row() {
              Button('-')
                .fontSize(18)
                .fontColor(Color.White)
                .backgroundColor('transparent')
                .onClick(() => {
                  if (this.repetitions > 1) {
                    this.repetitions -= 1;
                  }
                })

              Text(this.repetitions.toString())
                .fontSize(16)
                .fontColor(Color.White)
                .width(50)
                .textAlign(TextAlign.Center)

              Button('+')
                .fontSize(18)
                .fontColor(Color.White)
                .backgroundColor('transparent')
                .onClick(() => {
                  this.repetitions += 1;
                })
            }
            .width('64%')
            .height(34)
            .borderRadius(22)
            .backgroundColor('#333333')
            .justifyContent(FlexAlign.SpaceEvenly)
          }
          .width('90%')
          .height(40)
          .margin({ bottom: 8 })

          // Save and start button
          Button('Save and Start')
            .width('70%')
            .height(40)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .backgroundColor('#243A6A')
            .borderRadius(22)
            .margin({ top: 8 })
            .onClick(() => {
              this.pageStack.pushPathByName(
                TIMER_PAGE, new TimerPageParam(this.fastDuration, this.slowDuration, this.repetitions)
              );
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Black)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 24, left: 10, right: 10 })
      }
      .height('100%')
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PagesMap)
    .hideBackButton(true)
    .ignoreLayoutSafeArea()
  }
}