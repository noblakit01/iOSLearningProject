//
//  PHPhotoLibrary+rx.swift
//  Combinestagram
//
//  Created by luantran on 10/4/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

import Foundation
import RxSwift
import Photos

extension PHPhotoLibrary {
  
  static var authorized: Observable<Bool> {
    return Observable.create { observer in
      if authorizationStatus() == .authorized {
        observer.onNext(true)
        observer.onCompleted()
      } else {
        observer.onNext(false)
        requestAuthorization { newStatus in
          observer.onNext(newStatus == .authorized)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
}
