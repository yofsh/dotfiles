// ==UserScript==
// @name         Custom HTML5 video hotkeys
// @version      0.2
// @match        *://*/*
// @exclude      http://srv:8123*
// @exclude      http://192.168.1.50:8123*
// @grant        none
// ==/UserScript==

(function () {
  let originalTitle = document.title;
  let titleTimeout;

  function showSpeedInTitle(speed) {
    if (!document.title.startsWith("[ ") && !document.title.endsWith(" ]")) {
      originalTitle = document.title;
    }
    document.title = `[ ${speed.toFixed(1)} ]`;
    clearTimeout(titleTimeout);
    titleTimeout = setTimeout(() => {
      document.title = originalTitle;
    }, 200);
  }

  function setAllVideosSpeed(speed) {
    document.querySelectorAll("video").forEach((video) => {
      video.playbackRate = speed;
    });
    document.querySelectorAll("iframe").forEach((iframe) => {
      try {
        iframe.contentWindow.document.querySelectorAll("video").forEach((video) => {
          video.playbackRate = speed;
        });
      } catch (e) {}
    });
    showSpeedInTitle(speed);
    console.log("Set video speed to", speed);
  }

  function getFirstVideo() {
    return document.querySelector("video");
  }

  function handleWheel(e) {
    if (!e.shiftKey) return;
    const video = getFirstVideo();
    if (!video) return;
    if (e.ctrlKey) {
      const seekDelta = e.wheelDelta < 0 ? -5 : 5;
      video.currentTime += seekDelta;
      e.stopPropagation();
      return;
    }
    const speedDelta = e.wheelDelta < 0 ? -0.1 : 0.1;
    const newSpeed = Math.max(0.1, video.playbackRate + speedDelta);
    setAllVideosSpeed(newSpeed);
  }

  function handleKeyDown(e) {
    const video = getFirstVideo();
    if (!video) return;

    function matchHotkey(hotkey, e) {
      const parts = hotkey.split("+");
      const key = parts.pop();
      const needCtrl = parts.includes("Ctrl");
      const needAlt = parts.includes("Alt");
      const needShift = parts.includes("Shift");
      
      // Check if any other modifier keys are pressed
      if (e.metaKey || (!needCtrl && e.ctrlKey) || (!needAlt && e.altKey) || (!needShift && e.shiftKey)) {
        return false;
      }

      if (key.startsWith("Digit")) {
        return (
          e.code === key &&
          e.ctrlKey === needCtrl &&
          e.altKey === needAlt &&
          e.shiftKey === needShift
        );
      }
      return (
        e.key === key &&
        e.ctrlKey === needCtrl &&
        e.altKey === needAlt &&
        e.shiftKey === needShift
      );
    }

    const numKeys = ["1","2","3","4","5","6","7","8","9"];
    const digitCodes = ["Digit1","Digit2","Digit3","Digit4","Digit5","Digit6","Digit7","Digit8","Digit9"];
    const hotkeys = [
      ["Ctrl+9", () => {
        const iframe = document.querySelector("iframe:not(#cmdline_iframe)");
        if (iframe?.src) window.open(iframe.src, "_blank");
      }],
      ["Alt+ ", () => video.requestFullscreen()],
      ...digitCodes.slice(0,7).map((code, i) => ["Shift+"+code, () => setAllVideosSpeed(Math.max(1, (i+1)/2))]),
      ...numKeys.slice(0,7).map(k => ["Ctrl+"+k, () => setAllVideosSpeed(Math.max(1, parseInt(k,10)/2))]),
      ["Shift+ArrowLeft", () => { video.currentTime = Math.max(0, video.currentTime - 10 * video.playbackRate); }],
      ["Shift+ArrowRight", () => { video.currentTime = Math.min(video.duration, video.currentTime + 10 * video.playbackRate); }],
      ...numKeys.map(k => [k, () => { video.currentTime = video.duration * (parseInt(k,10)*0.1); }]),
    ];

    for (const [hotkey, handler] of hotkeys) {
      if (matchHotkey(hotkey, e)) {
        handler(e.key);
        e.preventDefault();
        return;
      }
    }
  }

  function init() {
    console.log("Initializing custom video hotkeys");
    document.body.addEventListener("wheel", handleWheel);
    document.body.addEventListener("keydown", handleKeyDown, false);
  }

  init();
})();
