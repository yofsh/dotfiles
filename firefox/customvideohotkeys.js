// ==UserScript==
// @name         Custom HTML5 video hotkeys
// @version      0.1
// @match        *://*/*
// @exclude    http://srv:8123*
// @exclude    http://192.168.1.50:8123*
// @grant        none
// ==/UserScript==

(function () {
  let documentTitle = document.title;
  let timeout;

  console.log("Initializing custom hotkeys");

  const setVideosSpeed = (speed) => {
    if (!document.title.startsWith("[ ") && !document.title.endsWith(" ]")) {
      documentTitle = document.title;
    }
    console.log("setting new speed", speed);
    [...document.querySelectorAll("video")].forEach((vd) => {
      vd.playbackRate = speed;
    });

    [...document.querySelectorAll("iframe")].forEach((iframe) => {
      try {
        [...iframe.contentWindow.document.querySelectorAll("video")].forEach(
          (vd) => {
            vd.playbackRate = speed;
          },
        );
      } catch (e) {
        console.error("Unable to access iframe:", e);
      }
    });
    document.title = `[ ${speed.toFixed(1)} ]`;
    clearTimeout(timeout);
    timeout = setTimeout(() => {
      document.title = documentTitle;
    }, 200);
  };

  const onMouseWheel = (e) => {
    if (!e.shiftKey) return;
    const v = document.querySelector("video");
    if (e.ctrlKey) {
      let delta = 5;
      if (e.wheelDelta < 0) {
        delta = -5;
      }
      v.currentTime = v.currentTime + delta;
      e.stopPropagation();
      return;
    }
    let delta = 0.1;
    if (e.wheelDelta < 0) {
      delta = -0.1;
    }
    const newRate = v.playbackRate + delta;
    setVideosSpeed(newRate);
  };
  document.body.addEventListener("wheel", onMouseWheel);

  const onKeyDown = (e) => {
    const videoSpeedMod = e.shiftKey;
    const videoSourceMod = e.altKey;
    if (e.key === " " && videoSourceMod) {
      document.querySelector("video")?.requestFullscreen();
    }
    if (!videoSpeedMod) {
      return;
    }

    // if (videoSourceMod) {
    //     switch (e.keyCode) {
    //         case 49: //1
    //             document.location.hostname = "youtube.com";
    //             break;
    //         case 50: //2
    //             document.location.hostname = "piped.kavin.rocks";
    //             break;
    //         case 51: //3
    //             document.location.hostname = "yewtu.be";
    //             break;
    //         default:
    //             break;
    //     }
    //     return;
    // }

    if (e.keyCode <= 48 || e.keyCode >= 55) {
      return;
    }

    const newSpeed = (e.keyCode - 47) / 2;
    setVideosSpeed(newSpeed >= 1 ? newSpeed : 1);
    console.log(`Keydown:`, e.keyCode, newSpeed);
  };
  document.body.addEventListener("keydown", onKeyDown, false);
})();
