# SpeechToTextDemo

From Apple's Documentation

To start using speech recognition in your app:

1. Write a sentence that tells users how they can use speech recognition in your app. For example, if your to-do list app changes an item's status to finished when the user speaks "done," you might write "Lets you mark an item as finished by saying Done."
2. Add the NSSpeechRecognitionUsageDescription key to your Info.plist file and provide the sentence you wrote as the string value.
3. Use request​Authorization:​ to request the user's permission by displaying the sentence you wrote in an alert.
    If the user denies permission (or if speech recognition is unavailable), handle it gracefully. For example, you might disable user interface items that indicate the availability of speech recognition.
4. After the user grants your app permission to perform speech recognition, create an SFSpeech​Recognizer object and create a speech recognition request.
   Use the SFSpeech​URLRecognition​Request class to perform recognition on a prerecorded, on-disk audio file, and use the SFSpeech​Audio​Buffer​Recognition​Request class to recognize live audio or in-memory content.
5. Pass the request to your SFSpeech​Recognizer object to begin recognition.
   Speech is recognized incrementally, so your recognizer's handler may be called more than once. (Check the value of the final property to find out when recognition is finished.) If you're working with live audio, you use SFSpeech​Audio​Buffer​Recognition​Request and append audio buffers to a request during the recognition process.
6. When recording is finished, signal the recognizer that no more audio is expected, so that recognition can finish. Note that starting a new recognition task before the previous one finishes interrupts the in-progress task.
