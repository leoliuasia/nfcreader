//
//  ViewController.swift
//  NFC Reader
//
//  Created by 刘平 on 2018/4/26.
//  Copyright © 2018 Leo Liu. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    private var nfcSession: NFCNDEFReaderSession?
    private var nfcReadQueue = DispatchQueue(label: "com.leo.ios.tutorials.corenfc.NFC-Reader.nfcReadQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nfcReadQueue, invalidateAfterFirstRead: true)
    }

    @IBAction func scanPressed(_ sender: Any) {
        if let nfcSession = self.nfcSession {
            nfcSession.begin()
        }
    }
}

// MARK: - NFCNDEFReaderSessionDelegate

extension ViewController: NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The NFCReaderSession was invalidated with error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.messageLabel.text = error.localizedDescription
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("didDetectNDEFs!")
        
        print(messages)
        
        let result = messages[0].records.compactMap({ String(data: $0.payload.advanced(by: 3), encoding: .utf8) }).joined(separator: "\n")
        DispatchQueue.main.async {
            self.messageLabel.text = result
        }
    }
    
}

