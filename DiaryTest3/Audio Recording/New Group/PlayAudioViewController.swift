
import AVFoundation
import UIKit

class PlayAudioViewController: UIViewController {
    
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var rate: Float! = 1
    var pitch: Float! = 0
    var echo: Bool! = false
    var reverb: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        fileNameLabel.text = recordedAudioURL.lastPathComponent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    // MARK: - Actions
    
    @IBAction func playAudio(_ sender: Any) {
        playSound(rate: self.rate,
                  pitch: self.pitch,
                  echo: self.echo,
                  reverb: self.reverb)
        configureUI(.playing)
    }

    @IBAction func stopAudio(_ sender: Any) {
        stopSound()
    }
    
    @IBAction func EditAudio(_ sender: Any) {
        let editAudioVC = storyboard?.instantiateViewController(withIdentifier: "editAudioVC") as! EditAudioViewController
        self.navigationController?.pushViewController(editAudioVC, animated: true)
        
//        performSegue(withIdentifier: "EditAudioSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditAudioSegue" {
            let playAudioVC = segue.destination as! EditAudioViewController
            playAudioVC.rate = self.rate
            playAudioVC.pitch = self.pitch
            playAudioVC.echo = self.echo
            playAudioVC.reverb = self.reverb
        }
    }
}
