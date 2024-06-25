% rebase('templates/skeleton.tpl', title=title)


<h3 class="mt-5">{{"Training" if get("train", False) else "Rating"}}</h3>

<div class="d-flex flex-column justify-content-center gap-2">
  <video controls id="playback-video">
    <source type="video/mp4">
  </video>

  <button onclick="playLoadedVideo()" disabled id="play-button" class="btn btn-success">Play</button>
</div>

<script type="text/javascript">
  function play(stimuli_idx) {
    console.log("play: stimuli_idx:" + stimuli_idx);
    fetch(`/play/${stimuli_idx}`)
      .then(r => r.text())
      .then(videoPath => {
        const videoPlayer = document.querySelector('video[id="playback-video"]');
        const playerSource = videoPlayer.querySelector('source');
        const playButton = document.querySelector('button[id="play-button"]');
        
        playerSource.src = `http://{{ host }}:{{ port }}/${videoPath}`.replaceAll('\\', '/');
        videoPlayer.load();

        playButton.removeAttribute('disabled');
      });
  }

  function playLoadedVideo() {
    const videoPlayer = document.querySelector('video[id="playback-video"]');

    videoPlayer.play().then(() => {
      // Try to make the video element go full screen
      if (videoPlayer.requestFullscreen) {
          videoPlayer.requestFullscreen();
      } else if (videoPlayer.mozRequestFullScreen) { // Firefox
          videoPlayer.mozRequestFullScreen();
      } else if (videoPlayer.webkitRequestFullscreen) { // Chrome, Safari, and Opera
          videoPlayer.webkitRequestFullscreen();
      } else if (videoPlayer.msRequestFullscreen) { // IE/Edge
          videoPlayer.msRequestFullscreen();
      }
    }).catch(function(error) {
        console.log('Playback error: ' + error);
    });

    videoPlayer.addEventListener('ended', exitFullscreenAndRemoveListener);
  }

  function exitFullscreenAndRemoveListener() {
    var videoPlayer = document.getElementById('videoPlayer');

    // Exit fullscreen mode
    if (document.exitFullscreen) {
        document.exitFullscreen();
    } else if (document.mozCancelFullScreen) { // Firefox
        document.mozCancelFullScreen();
    } else if (document.webkitExitFullscreen) { // Chrome, Safari, and Opera
        document.webkitExitFullscreen();
    } else if (document.msExitFullscreen) { // IE/Edge
        document.msExitFullscreen();
    }

    // Remove the event listener
    videoPlayer.removeEventListener('ended', exitFullscreenAndRemoveListener);  
  }

  play("{{stimuli_idx}}");
</script>

<div class="row" id="rating_template" style="padding-top: 1em">
% include('templates/' + rating_template, stimuli_idx=stimuli_idx, stimuli_file=stimuli_file, train=get("train", False), question=question)
</div>

% include('templates/progress_bar.tpl', stimuli_done=stimuli_done, stimuli_count=stimuli_count)

