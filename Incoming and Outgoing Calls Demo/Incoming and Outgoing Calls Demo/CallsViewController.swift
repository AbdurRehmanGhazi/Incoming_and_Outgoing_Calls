//
//  ViewController.swift
//  Incoming and Outgoing Calls Demo
//
//  Created by AbdurRehmanNineSol on 22/09/2022.
//

import UIKit
import CallKit

private let presentIncomingCallViewControllerSegue = "PresentIncomingCallViewController"
private let presentOutgoingCallViewControllerSegue = "PresentOutgoingCallViewController"
private let callCellIdentifier = "CallCell"

class CallsViewController: UITableViewController {
  var callManager: CallManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    callManager = AppDelegate.shared.callManager
    
    callManager.callsChangedHandler = { [weak self] in
      guard let self = self else { return }
      self.tableView.reloadData()
    }
  }
  
  @IBAction private func unwindForNewCall(_ segue: UIStoryboardSegue) {
    guard
      let newCallController = segue.source as? NewCallViewController,
      let handle = newCallController.handle
      else {
        return
    }
    
    let videoEnabled = newCallController.videoEnabled
    let incoming = newCallController.incoming
    
    if incoming {
      let backgroundTaskIdentifier =
        UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//          CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.ninesol.Incoming-and-Outgoing-Calls-Demo.HotlineDirectory") { error in
//              if let error = error {
//                print(error.localizedDescription)
//
//              } else {
//                print("success")
//              }
//          }
        AppDelegate.shared.displayIncomingCall( uuid: UUID(), handle: handle, hasVideo: videoEnabled) { _ in
          UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        }
      }
    } else {
      callManager.startCall(handle: handle, videoEnabled: videoEnabled)
    }
  }
}

// MARK: - UITableViewDataSource
extension CallsViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return callManager.calls.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let call = callManager.calls[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: callCellIdentifier)
      as! CallTableViewCell
    cell.callerHandle = call.handle
    cell.callState = call.state
    cell.incoming = !call.outgoing
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let call = callManager.calls[indexPath.row]
    callManager.end(call: call)
  }
}

// MARK - UITableViewDelegate
extension CallsViewController {
  override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "End"
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let call = callManager.calls[indexPath.row]
    call.state = call.state == .held ? .active : .held
    callManager.setHeld(call: call, onHold: call.state == .held)
    
    tableView.reloadData()
  }
}

