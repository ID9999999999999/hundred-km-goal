(()=>{'use strict';
const steps=['index','restaurant','food','dessert','day','time','surprise','finish'];
const labels={restaurant:'Ресторан',food:'Хоол',dessert:'Амттан',day:'Өдөр',time:'Цаг',surprise:'Бяцхан сюрприз'};
const page=document.body.dataset.page;
function getSelections(){try{return JSON.parse(localStorage.getItem('mongolian-love-plan-v2')||'{}')}catch(e){return {}}}
function save(key,value){const s=getSelections();s[key]=value;try{localStorage.setItem('mongolian-love-plan-v2',JSON.stringify(s))}catch(e){}}
function toast(msg){const el=document.querySelector('.notice');if(!el)return;el.textContent=msg;el.classList.add('show');clearTimeout(window._noticeTimer);window._noticeTimer=setTimeout(()=>el.classList.remove('show'),2600)}
function go(url){window.location.href=url}
const hearts=['💕','💖','💗','💘','❤️'];const field=document.querySelector('.heartfield');if(field&&!window.matchMedia('(prefers-reduced-motion: reduce)').matches){function spawn(){const e=document.createElement('span');e.className='floating';e.textContent=hearts[Math.floor(Math.random()*hearts.length)];e.style.left=Math.random()*100+'%';e.style.fontSize=(17+Math.random()*25)+'px';e.style.animationDuration=(7+Math.random()*7)+'s';field.appendChild(e);setTimeout(()=>e.remove(),15000)}for(let i=0;i<9;i++)setTimeout(spawn,i*130);setInterval(spawn,1150)}
if(page==='index'){
 const no=document.getElementById('no-btn');const yes=document.getElementById('yes-btn');const dialog=document.getElementById('no-dialog');
 yes?.addEventListener('click',()=>go('restaurant.html'));
 no?.addEventListener('click',()=>{dialog.classList.add('open');dialog.setAttribute('aria-hidden','false');document.getElementById('dialog-yes')?.focus()});
 document.getElementById('dialog-yes')?.addEventListener('click',()=>go('restaurant.html'));
 document.getElementById('dialog-back')?.addEventListener('click',()=>{dialog.classList.remove('open');dialog.setAttribute('aria-hidden','true');yes?.focus()});
 dialog?.addEventListener('click',e=>{if(e.target===dialog)dialog.classList.remove('open')});
 document.addEventListener('keydown',e=>{if(e.key==='Escape')dialog?.classList.remove('open')});
}
const grid=document.getElementById('options');if(grid){
 const prev=getSelections()[page];
 function update(value){[...grid.querySelectorAll('[data-choice]')].forEach(b=>{const selected=b.dataset.choice===value;b.classList.toggle('selected',selected);b.setAttribute('aria-pressed',selected?'true':'false')});const next=document.getElementById('continue-btn');if(next)next.disabled=false;}
 grid.querySelectorAll('[data-choice]').forEach(b=>{b.addEventListener('click',()=>{const val=b.dataset.choice;save(page,val);update(val);const d=document.querySelector('.other-date');if(d)d.classList.toggle('visible',val==='Өөр өдөр')});});
 if(prev){update(prev);if(page==='day'&&prev==='Өөр өдөр')document.querySelector('.other-date')?.classList.add('visible')}
 document.getElementById('continue-btn')?.addEventListener('click',()=>{
  const selected=getSelections()[page];if(!selected){toast('Эхлээд нэгийг нь сонгоорой 💗');return}
  if(page==='day'&&selected==='Өөр өдөр'){
   const input=document.getElementById('custom-day');if(!input?.value){toast('Уулзах өдрөө бичээрэй 🌸');input?.focus();return}
   save('customDay',input.value)
  }
  go(document.body.dataset.next+'.html');
 });
}
if(page==='finish'){
 const s=getSelections();const container=document.getElementById('summary-list');
 if(container){for(const key of Object.keys(labels)){const card=document.createElement('div');card.className='summary';const label=document.createElement('small');label.textContent=({restaurant:'🥂',food:'🍽️',dessert:'🍰',day:'📅',time:'🕰️',surprise:'🌹'}[key]||'💗')+' '+labels[key];const value=document.createElement('strong');value.textContent=key==='day'&&s[key]==='Өөр өдөр'&&s.customDay?s.customDay:(s[key]||'Сонгоогүй');card.append(label,value);container.append(card)}}
 const out='💖 Бидний болзооны төлөвлөгөө 💖\n'+Object.keys(labels).map(k=>labels[k]+': '+(k==='day'&&s[k]==='Өөр өдөр'?(s.customDay||'Өөр өдөр'):(s[k]||'Сонгоогүй'))).join('\n')+'\n\nЧамтай уулзахыг тэсэн ядан хүлээж байна! 🌹';
 document.getElementById('copy-btn')?.addEventListener('click',async()=>{try{await navigator.clipboard.writeText(out);toast('Хууллаа! 💌 Одоо илгээгээрэй.')}catch(e){window.prompt('Энэ мессежийг хуулж аваарай:',out)}});
 document.getElementById('share-btn')?.addEventListener('click',async()=>{if(navigator.share){try{await navigator.share({title:'Бидний болзоо',text:out});return}catch(e){if(e.name==='AbortError')return}}window.open('https://wa.me/?text='+encodeURIComponent(out),'_blank','noopener,noreferrer')});
 document.getElementById('restart-btn')?.addEventListener('click',()=>{try{localStorage.removeItem('mongolian-love-plan-v2')}catch(e){}go('index.html')});
}
})();