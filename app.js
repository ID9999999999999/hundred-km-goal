(()=>{
  'use strict';

  const page = document.body.dataset.page;
  const labels = {
    restaurant: 'Ресторан', food: 'Хоол', dessert: 'Амттан',
    day: 'Өдөр', time: 'Цаг', surprise: 'Бяцхан сюрприз'
  };
  const storageKey = 'mongolian-love-plan-v2';
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const rand = (min,max)=> Math.random()*(max-min)+min;

  function getSelections(){
    try {return JSON.parse(localStorage.getItem(storageKey)||'{}')||{};}
    catch(e){return {};}
  }
  function save(key,value){
    const s=getSelections(); s[key]=value;
    try {localStorage.setItem(storageKey,JSON.stringify(s));}catch(e){}
  }
  function toast(message){
    const el=document.querySelector('.notice'); if(!el)return;
    el.textContent=message; el.classList.add('show');
    clearTimeout(window._noticeTimer);
    window._noticeTimer=setTimeout(()=>el.classList.remove('show'),3300);
  }
  function go(url){ window.location.assign(url); }
  function navigateSweetly(url){
    if(prefersReducedMotion){go(url);return;}
    const overlay=document.createElement('div');
    overlay.className='page-transition';
    overlay.textContent=['💘','💕','💖','🌹'][Math.floor(rand(0,4))];
    overlay.setAttribute('aria-hidden','true');
    document.body.appendChild(overlay);
    setTimeout(()=>go(url),520);
  }
  function burst(x,y,count=9){
    if(prefersReducedMotion)return;
    for(let i=0;i<count;i++){
      const particle=document.createElement('span');
      particle.className='burst-heart'; particle.textContent=['💗','✨','💕','💖','🌸'][i%5];
      particle.style.left=x+'px'; particle.style.top=y+'px';
      particle.style.setProperty('--dx',rand(-110,110).toFixed(0)+'px');
      particle.style.setProperty('--dy',rand(-165,-55).toFixed(0)+'px');
      particle.style.animationDelay=i*24+'ms';
      document.body.appendChild(particle);
      setTimeout(()=>particle.remove(),1300);
    }
  }
  function party(count=30){
    for(let i=0;i<count;i++)setTimeout(()=>{
      burst(rand(45,window.innerWidth-45),rand(window.innerHeight*.35,window.innerHeight*.8),1);
    },i*25);
  }

  // The hearts live behind the text and never interrupt a button tap.
  const hearts=['💕','💖','💗','💘','❤️','🌸'];
  const field=document.querySelector('.heartfield');
  if(field&&!prefersReducedMotion){
    function spawn(){
      const e=document.createElement('span');e.className='floating';
      e.textContent=hearts[Math.floor(rand(0,hearts.length))];
      e.style.left=rand(2,97)+'%';
      e.style.fontSize=rand(17,38)+'px';
      e.style.animationDuration=rand(8,15)+'s';
      field.appendChild(e);setTimeout(()=>e.remove(),15500);
    }
    for(let i=0;i<7;i++)setTimeout(spawn,i*200);
    setInterval(spawn,1350);
  }
  document.addEventListener('click',e=>{
    if(e.target.closest('.overlay'))return;
    if(e.clientX>=0&&e.clientY>=0)burst(e.clientX,e.clientY,5);
  });

  // A silly, optional love fortune on every separate page.
  const fortunes={
    index: [
      'Чиний инээмсэглэл миний Wi-Fi-г хүртэл хүчтэй болгодог! 📶💗',
      'Хайрын цаг агаар: 100% догдлол, бороо орохгүй! ☀️',
      'Зүрхний GPS ганцхан чам руу л зааж байна! 🧭💘'
    ],
    restaurant: [
      'Ширээ хоёр хүнийх, харин инээд хязгааргүй! 🍽️',
      'Рестораны нууц жор: чиний инээмсэглэл + миний догдлол. 👩‍🍳💕',
      'Энэ үдшийн хамгийн гоё чимэглэл нь чи! 🌷'
    ],
    food: [
      'Бүх хоол амттай. Гэхдээ хамт идэхээр бүр ч амттай! 😋',
      'Хайрын тогооч: 1 халбага инээд, 2 халбага догдлол! 👨‍🍳',
      'Хоолны дуршил: 100%. Чамайг харах догдлол: 200%! 🍜'
    ],
    dessert: [
      'Анхаар: чиний инээмсэглэл шоколадаас ч амттай! 🍫',
      'Калори тоолохгүй ээ, хөөрхөн дурсамж л цуглуулна! 🍰',
      'Амттангийн нууц орц: жаахан ид шид ✨'
    ],
    day: [
      'Хуанли хүртэл энэ өдрийг зүрхээр тэмдэглэчихлээ! 💘',
      'Азтай өдөр гэдэг нь чамтай уулзах өдөр байх нь! 📅'
    ],
    time: [
      'Цаг хүртэл хурдан явах гээд догдолж байна! ⏰💞',
      'Хэдэн цаг байх нь хамаагүй, хамтдаа байх нь чухал! 🌙'
    ],
    surprise: [
      'Сюрприз задлагдлаа: хамгийн гоё бэлэг нь дурсамж! 🎁',
      'Ид шидийн томъёо: чи + би + инээд = 🌈'
    ],
    finish: [
      'Албан ёсоор батлагдлаа: хамгийн гоё болзоо инээдээс эхэлдэг! 💖',
      'Бидний төлөвлөгөөг зүрх баталлаа! ✅💗'
    ]
  };
  const panel=document.querySelector('.panel');
  if(panel){
    const magic=document.createElement('div'); magic.className='mini-magic';
    const btn=document.createElement('button');btn.className='fortune-btn'; btn.type='button';
    btn.textContent='🔮 Хайрын зөгнөл харах';
    const result=document.createElement('p');result.className='fortune-result';
    result.setAttribute('role','status');result.setAttribute('aria-live','polite');
    magic.append(btn,result); panel.append(magic);
    let fortuneIndex=0;
    btn.addEventListener('click',()=>{
      const set=fortunes[page]||fortunes.index;
      result.textContent=set[fortuneIndex%set.length];fortuneIndex++;
      magic.classList.add('revealed');
      burst(window.innerWidth/2,window.innerHeight*.55,13);
    });
  }

  if(page==='index'){
    const no=document.getElementById('no-btn');
    const yes=document.getElementById('yes-btn');
    const dialog=document.getElementById('no-dialog');
    let dodges=0;
    let lastDodge=0;
    const jokes=[
      'Өө! “Үгүй” товч зугтчихлаа! 🏃‍♀️💘',
      'Барих гэж оролдоод үз! Товч нуугдаж байна! 🙈',
      'Хайрын хамгаалалтын систем ажиллаж байна! 🚨💖',
      'Товч ядарчээ. Одоо ярилцъя! 😂'
    ];
    function showNoDialog(){
      if(!dialog)return;
      dialog.classList.add('open');dialog.setAttribute('aria-hidden','false');
      document.getElementById('dialog-yes')?.focus();
      if(no){no.classList.remove('dodging');no.style.left='';no.style.top='';}
    }
    function closeDialog(){
      dialog?.classList.remove('open');dialog?.setAttribute('aria-hidden','true');
      yes?.focus();
    }
    function dodge(){
      if(!no)return;
      if(dodges>=4){showNoDialog();return;}
      const now=Date.now();if(now-lastDodge<200)return;
      lastDodge=now;dodges++;
      const width=no.offsetWidth||120, height=no.offsetHeight||50;
      const pad=18;
      // Keep the escaping button entirely visible, even on narrow phones.
      const maxX=Math.max(pad,window.innerWidth-width-pad);
      const maxY=Math.max(pad,window.innerHeight-height-pad);
      const targetX=rand(pad,maxX),targetY=rand(pad,maxY);
      no.classList.add('dodging');
      no.style.left=targetX.toFixed(0)+'px';no.style.top=targetY.toFixed(0)+'px';
      no.style.transform=`rotate(${rand(-9,9).toFixed(0)}deg)`;
      toast(jokes[Math.min(dodges-1,jokes.length-1)]);
      if(dodges===4)setTimeout(showNoDialog,420);
    }
    no?.addEventListener('pointerenter',e=>{
      if(e.pointerType==='mouse' && window.matchMedia('(hover:hover)').matches)dodge();
    });
    no?.addEventListener('pointerdown',e=>{
      if(e.pointerType!=='mouse'){e.preventDefault();dodge();}
    });
    // Keyboard/switch users can always open the dialog directly.
    no?.addEventListener('click',e=>{e.preventDefault();showNoDialog();});
    yes?.addEventListener('click',()=>{
      burst(window.innerWidth*.45,window.innerHeight*.52,22);
      toast('Зүрх минь баярлаад бүжиглэж байна! 💃💗');
      setTimeout(()=>navigateSweetly('restaurant.html'),420);
    });
    document.getElementById('dialog-yes')?.addEventListener('click',()=>navigateSweetly('restaurant.html'));
    document.getElementById('dialog-back')?.addEventListener('click',closeDialog);
    document.getElementById('dialog-decline')?.addEventListener('click',()=>{
      closeDialog();
      toast('Мэдээж! Чиний шийдвэрийг хүндэтгэнэ. 🤍');
      if(no){no.classList.remove('dodging');no.style.transform='';no.style.left='';no.style.top='';}
    });
    dialog?.addEventListener('click',e=>{if(e.target===dialog)closeDialog();});
    document.addEventListener('keydown',e=>{if(e.key==='Escape')closeDialog();});

    const radar=document.createElement('div');radar.className='love-radar';
    radar.innerHTML='<div class="radar-title">💓 Зүрхний радар</div><div class="radar-track"><span></span></div><p class="radar-result" role="status" aria-live="polite">Тооцоолж үзэх үү? 😏</p>';
    const radarBtn=document.createElement('button');radarBtn.type='button';radarBtn.className='radar-btn';radarBtn.textContent='💌 Хайрын түвшинг хэмжих';
    radar.prepend(radarBtn);
    const sign=panel.querySelector('.smallsign'); if(sign)sign.before(radar); else panel.appendChild(radar);
    radarBtn.addEventListener('click',()=>{
      radar.classList.add('active');
      radar.querySelector('.radar-track span').style.width='99.9%';
      radar.querySelector('.radar-result').textContent='99.9% ❤️ Үлдсэн 0.1% нь пиццанд дурласан байна! 🍕😂';
      radarBtn.textContent='💖 Дахин шалгахад ч 99.9%!';
      burst(window.innerWidth*.42,window.innerHeight*.65,15);
    });
  }

  // Regular steps: funny compliments, tiny animation and preserved choices.
  const grid=document.getElementById('options');
  if(grid){
    const prev=getSelections()[page];
    const compliments={
      restaurant:'Суудал захиалаагүй ч миний зүрхэнд чамд суудал бэлэн! 🥂',
      food:'Амттай сонголт! Тогооч хүртэл баярлаж байна! 👨‍🍳💗',
      dessert:'Чихэрлэг сонголт! Шүдний эмчид битгий хэлээрэй! 🤫🍰',
      day:'Календарь хүртэл догдлоод эхэллээ! 📆💖',
      time:'Бидний болзооны цаг албан ёсоор хөөрхөн боллоо! 🕰️',
      surprise:'Энэ сюрпризийг зүрх алга ташиж байна! 👏💕'
    };
    function update(value){
      grid.querySelectorAll('[data-choice]').forEach(b=>{
        const selected=b.dataset.choice===value;
        b.classList.toggle('selected',selected);
        b.setAttribute('aria-pressed',selected?'true':'false');
      });
      const next=document.getElementById('continue-btn');if(next)next.disabled=false;
    }
    grid.querySelectorAll('[data-choice]').forEach(b=>{
      b.addEventListener('click',()=>{
        const val=b.dataset.choice;
        save(page,val);update(val);
        document.querySelector('.other-date')?.classList.toggle('visible',val==='Өөр өдөр');
        const r=b.getBoundingClientRect();burst(r.left+r.width/2,r.top+r.height/2,10);
        toast(compliments[page]||'Ямар хөөрхөн сонголт вэ! 💘');
      });
    });
    if(prev){
      update(prev);
      if(page==='day'&&prev==='Өөр өдөр')document.querySelector('.other-date')?.classList.add('visible');
      const input=document.getElementById('custom-day');if(input&&getSelections().customDay)input.value=getSelections().customDay;
    }
    document.getElementById('continue-btn')?.addEventListener('click',()=>{
      const selected=getSelections()[page];
      if(!selected){toast('Эхлээд нэгийг нь сонгоорой 💗');return;}
      if(page==='day'&&selected==='Өөр өдөр'){
        const input=document.getElementById('custom-day');
        if(!input?.value){toast('Уулзах өдрөө сонгоорой 🌸');input?.focus();return;}
        save('customDay',input.value);
      }
      navigateSweetly(document.body.dataset.next+'.html');
    });
  }

  if(page==='surprise'&&panel){
    const gift=document.createElement('div');gift.className='gift-station';
    const btn=document.createElement('button');btn.type='button';btn.className='gift-button';
    btn.textContent='🎁 Нууц хайрцгийг нээх';
    const result=document.createElement('div');result.className='gift-message';result.setAttribute('role','status');
    gift.append(btn,result);
    const progress=panel.querySelector('.progressbox');
    if(progress)progress.before(gift);else panel.appendChild(gift);
    btn.addEventListener('click',()=>{
      btn.textContent='🎉 Нээгдлээ!';
      result.textContent='Эндээс 1000 инээмсэглэл, нэг хөөрхөн орой олдлоо! 💕';
      gift.classList.add('opened');party(25);
    });
  }

  if(page==='finish'){
    const s=getSelections();
    const container=document.getElementById('summary-list');
    if(container){
      for(const key of Object.keys(labels)){
        const card=document.createElement('div');card.className='summary';
        const label=document.createElement('small');
        label.textContent=({restaurant:'🥂',food:'🍽️',dessert:'🍰',day:'📅',time:'🕰️',surprise:'🌹'}[key]||'💗')+' '+labels[key];
        const value=document.createElement('strong');
        value.textContent=key==='day'&&s[key]==='Өөр өдөр'&&s.customDay?s.customDay:(s[key]||'Сонгоогүй');
        card.append(label,value);container.append(card);
      }
    }
    const out='💖 Бидний болзооны төлөвлөгөө 💖\n'+Object.keys(labels).map(k=>labels[k]+': '+(k==='day'&&s[k]==='Өөр өдөр'?(s.customDay||'Өөр өдөр'):(s[k]||'Сонгоогүй'))).join('\n')+'\n\nЧамтай уулзахыг тэсэн ядан хүлээж байна! 🌹';
    document.getElementById('copy-btn')?.addEventListener('click',async()=>{
      try{await navigator.clipboard.writeText(out);toast('Хууллаа! 💌 Одоо илгээгээрэй.');}
      catch(e){window.prompt('Энэ мессежийг хуулж аваарай:',out);}
    });
    document.getElementById('share-btn')?.addEventListener('click',async()=>{
      if(navigator.share){
        try{await navigator.share({title:'Бидний болзоо',text:out});return;}
        catch(e){if(e.name==='AbortError')return;}
      }
      window.open('https://wa.me/?text='+encodeURIComponent(out),'_blank','noopener,noreferrer');
    });
    document.getElementById('restart-btn')?.addEventListener('click',()=>{
      try{localStorage.removeItem(storageKey);}catch(e){}
      go('index.html');
    });
    // The final secret love note is separate from the actual plan.
    const secret=document.createElement('div');secret.className='final-secret';
    const letter=document.createElement('button');letter.className='gift-button';letter.type='button';
    letter.textContent='💌 Нууц хайрын захиа';
    const note=document.createElement('p');note.className='secret-note';note.setAttribute('role','status');
    secret.append(letter,note);
    panel.querySelector('.closing')?.after(secret);
    letter.addEventListener('click',()=>{
      secret.classList.add('opened');
      note.textContent='Зарим уулзалт санамсаргүй эхэлдэг. Харин хамгийн гоё дурсамжууд инээмсэглэлээс эхэлдэг. Чамтай хамт инээхийг хүсэж байна. 💗';
      party(22);
    });
    setTimeout(()=>party(12),320);
  }
})();
