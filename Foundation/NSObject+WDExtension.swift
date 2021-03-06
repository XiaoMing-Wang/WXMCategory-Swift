//
//  NSObject+WXMExtension.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/5/27.
//  Copyright © 2020 wq. All rights reserved.
//

import Foundation

private var timerKey :Void?
extension NSObject {
    
    /**< 定时器 */
    @discardableResult
    func startTimingInterval_k(_ interval: Double, countdown: @escaping () -> Bool) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(queue: .global())
        timer.schedule(deadline: .now(), repeating: interval)
        timer.setEventHandler {
            DispatchQueue.main.async {
                let isContinue: Bool = countdown()
                isContinue ? () : timer.cancel()
            }
        }

        timer.resume()
        objc_setAssociatedObject(self, &timerKey, timer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return timer
    }

    /**< 定时器 */
    @discardableResult
    func startTimingInterval_k(_ interval: Double, target: AnyObject, action: Selector) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(queue: .global())
        timer.schedule(deadline: .now(), repeating: interval)
        timer.setEventHandler { [weak target] in
            DispatchQueue.main.async {
                _ = target?.perform(action)
            }
        }
        objc_setAssociatedObject(self, &timerKey, timer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        timer.resume()
        return timer
    }

    /**< 停止定时器 */
    func stopTiming_k() {
        let timer = objc_getAssociatedObject(self, &timerKey) as? DispatchSourceTimer
        timer?.cancel()
    }

}

