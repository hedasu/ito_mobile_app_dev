/**
 * Pairly — Üniversite Proje Sunumu Kontrolcüsü
 * Klavye oklarıyla geçiş, tam ekran modu, slayt sayacı, konuşmacı notları,
 * Light/Dark tema geçişi, algoritma kart animasyonu ve Canlı Demo yedek galerisi.
 */
(function () {
  'use strict';

  const slides = Array.from(document.querySelectorAll('.slide'));
  const chapterBtns = Array.from(document.querySelectorAll('.chapter-btn'));
  const progressBar = document.getElementById('progressBar');
  const slideCounter = document.getElementById('slideCounter');
  const btnPrev = document.getElementById('btnPrev');
  const btnNext = document.getElementById('btnNext');
  const btnNotes = document.getElementById('btnNotes');
  const btnTheme = document.getElementById('btnTheme');
  const themeLabel = document.getElementById('themeLabel');
  const btnFullscreen = document.getElementById('btnFullscreen');
  const notesDrawer = document.getElementById('notesDrawer');
  const notesText = document.getElementById('notesText');

  // Slayt 4: Algoritma kart animasyonu adımları
  const algoSteps = Array.from(document.querySelectorAll('.algo-step-box'));

  // Slayt 9: Canlı Demo yedek galeri elemanları
  const galleryTabs = Array.from(document.querySelectorAll('.gallery-tab'));
  const demoPreviewImg = document.getElementById('demoPreviewImg');
  const demoPreviewBadge = document.getElementById('demoPreviewBadge');
  const demoPreviewTitle = document.getElementById('demoPreviewTitle');
  const demoPreviewDesc = document.getElementById('demoPreviewDesc');

  let currentSlide = 0;
  let notesOpen = false;
  let isDarkMode = false;
  let algoStepIndex = 0;

  function updateDeck() {
    const total = slides.length;

    slides.forEach((slide, idx) => {
      slide.classList.toggle('active', idx === currentSlide);
    });

    chapterBtns.forEach((btn, idx) => {
      btn.classList.toggle('active', idx === currentSlide);
    });

    const progressPct = ((currentSlide + 1) / total) * 100;
    if (progressBar) {
      progressBar.style.width = `${progressPct}%`;
    }

    if (slideCounter) {
      slideCounter.textContent = `${currentSlide + 1} / ${total}`;
    }

    if (btnPrev) {
      btnPrev.disabled = currentSlide === 0;
    }
    if (btnNext) {
      btnNext.disabled = currentSlide === total - 1;
    }

    const activeSlideEl = slides[currentSlide];
    if (notesText && activeSlideEl) {
      notesText.textContent = activeSlideEl.getAttribute('data-notes') || '';
    }
  }

  function goToSlide(index) {
    if (index < 0 || index >= slides.length) return;
    currentSlide = index;
    updateDeck();
  }

  function nextSlide() {
    if (currentSlide < slides.length - 1) {
      goToSlide(currentSlide + 1);
    }
  }

  function prevSlide() {
    if (currentSlide > 0) {
      goToSlide(currentSlide - 1);
    }
  }

  function toggleNotes() {
    notesOpen = !notesOpen;
    if (notesDrawer) {
      notesDrawer.classList.toggle('open', notesOpen);
    }
    if (btnNotes) {
      btnNotes.classList.toggle('active-toggle', notesOpen);
    }
  }

  function toggleTheme() {
    isDarkMode = !isDarkMode;
    document.body.classList.toggle('dark-mode', isDarkMode);
    if (themeLabel) {
      themeLabel.textContent = isDarkMode ? 'Açık Tema (T)' : 'Koyu Tema (T)';
    }
    if (btnTheme) {
      btnTheme.classList.toggle('active-toggle', isDarkMode);
    }
  }

  function toggleFullscreen() {
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen().catch(() => {});
    } else if (document.exitFullscreen) {
      document.exitFullscreen().catch(() => {});
    }
  }

  // Slayt 4 Kart Eşleştirme Süreci Animasyon Döngüsü
  if (algoSteps.length > 0) {
    setInterval(() => {
      if (currentSlide !== 3) return;
      algoStepIndex = (algoStepIndex + 1) % algoSteps.length;
      algoSteps.forEach((box, idx) => {
        box.classList.toggle('active-step', idx === algoStepIndex);
      });
    }, 1500);

    algoSteps.forEach((box, idx) => {
      box.addEventListener('click', () => {
        algoStepIndex = idx;
        algoSteps.forEach((b, i) => b.classList.toggle('active-step', i === idx));
      });
    });
  }

  // Buton Dinleyicileri
  if (btnPrev) btnPrev.addEventListener('click', prevSlide);
  if (btnNext) btnNext.addEventListener('click', nextSlide);
  if (btnNotes) btnNotes.addEventListener('click', toggleNotes);
  if (btnTheme) btnTheme.addEventListener('click', toggleTheme);
  if (btnFullscreen) btnFullscreen.addEventListener('click', toggleFullscreen);

  chapterBtns.forEach((btn) => {
    btn.addEventListener('click', () => {
      const target = parseInt(btn.getAttribute('data-slide') || '0', 10);
      goToSlide(target);
    });
  });

  // 9. Bölüm Yedek Ekran Galerisi Sekmeleri
  galleryTabs.forEach((tab) => {
    tab.addEventListener('click', () => {
      galleryTabs.forEach((t) => t.classList.remove('active'));
      tab.classList.add('active');

      const imgSrc = tab.getAttribute('data-img');
      const badge = tab.getAttribute('data-badge');
      const title = tab.getAttribute('data-title');
      const desc = tab.getAttribute('data-desc');

      if (demoPreviewImg && imgSrc) demoPreviewImg.src = imgSrc;
      if (demoPreviewBadge && badge) {
        demoPreviewBadge.textContent = badge;
        demoPreviewBadge.className = badge.includes('Gerçek')
          ? 'badge-real'
          : 'badge-stitch';
      }
      if (demoPreviewTitle && title) demoPreviewTitle.textContent = title;
      if (demoPreviewDesc && desc) demoPreviewDesc.textContent = desc;
    });
  });

  // Klavye Kısayolları
  document.addEventListener('keydown', (event) => {
    if (event.target instanceof HTMLInputElement || event.target instanceof HTMLTextAreaElement) {
      return;
    }

    switch (event.key) {
      case 'ArrowRight':
      case 'PageDown':
      case ' ':
        event.preventDefault();
        nextSlide();
        break;
      case 'ArrowLeft':
      case 'PageUp':
        event.preventDefault();
        prevSlide();
        break;
      case 'Home':
        event.preventDefault();
        goToSlide(0);
        break;
      case 'End':
        event.preventDefault();
        goToSlide(slides.length - 1);
        break;
      case 'f':
      case 'F':
        event.preventDefault();
        toggleFullscreen();
        break;
      case 'n':
      case 'N':
        event.preventDefault();
        toggleNotes();
        break;
      case 't':
      case 'T':
        event.preventDefault();
        toggleTheme();
        break;
      default:
        // 1-9 rakam tuşlarıyla doğrudan ilgili slayta geçiş
        if (event.key >= '1' && event.key <= '9') {
          const idx = parseInt(event.key, 10) - 1;
          goToSlide(idx);
        }
        break;
    }
  });

  // URL parametresi ile slayt seçimi (ör. ?slide=3)
  const params = new URLSearchParams(window.location.search);
  const initialParam = parseInt(params.get('slide') || '0', 10);
  if (!Number.isNaN(initialParam) && initialParam >= 0 && initialParam < slides.length) {
    currentSlide = initialParam;
  }

  // Başlangıç durumunu yükle
  updateDeck();
})();
