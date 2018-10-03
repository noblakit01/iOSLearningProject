//
//  UIViewController.swift
//  Combinestagram
//
//  Created by luantran on 10/3/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
  
  func alert(_ message: String, description: String? = nil) -> Completable {
    return Completable.create { [weak self] event -> Disposable in
      let alertViewController = UIAlertController(title: message, message: description, preferredStyle: .alert)
      let closeButton = UIAlertAction(title: "Close", style: .default, handler: { action in
        event(.completed)
      })
      alertViewController.addAction(closeButton)
      self?.present(alertViewController, animated: true, completion: nil)
      return Disposables.create {
        self?.dismiss(animated: true, completion: nil)
      }
    }
  }
  
}
