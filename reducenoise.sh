#!/bin/sh     
coded_by='

In the name of Allah, the most Gracious, the most Merciful.

 ▓▓▓▓▓▓▓▓▓▓
░▓ Author ▓ Abdullah <https://abdullah.today>
░▓▓▓▓▓▓▓▓▓▓
░░░░░░░░░░

░█▀▄░█▀▀░█▀▄░█░█░█▀▀░█▀▀░█▀█░█▀█░▀█▀░█▀▀░█▀▀
░█▀▄░█▀▀░█░█░█░█░█░░░█▀▀░█░█░█░█░░█░░▀▀█░█▀▀
░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀
'


# Ask for input file

read -p "Enter the path to video file: " input_file
cp $input_file .

# Create an audio stream

ffmpeg -i $input_file -acodec pcm_s16le -ar 128k -vn audio_stream.wav

# Create a video stream

ffmpeg -i $input_file -vcodec copy -an video_stream.mp4

# Ask for beginning and ending points of noise in file

read -p "Where the noise starts H:M:S: " noise_starts
read -p "Where the noise ends H:M:S: " noise_ends

# Create an audio with noise only

ffmpeg -i $input_file -acodec pcm_s16le -ar 128k -vn -ss $noise_starts -t $noise_ends audio_with_noise.wav

# Create noise profile

sox audio_with_noise.wav -n noiseprof noise.prof

# Clean the noise from audio stream

sox audio_stream.wav audio_without_noise.wav noisered noise.prof 0.21

# Merge the audio and video streams together 

ffmpeg -i video_stream.mp4 -i audio_without_noise.wav -map 0:v -map 1:a -c:v copy -c:a aac -b:a 128k final_video.mp4

echo "Here is your video with no noise. $pwd/final_video.mp4"
