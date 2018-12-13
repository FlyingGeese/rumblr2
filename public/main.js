console.log('Javascript loaded');

function updateText() {
    let title = document.getElementById('article-title');
    let text = document.getElementById('form-title');
    title.innerHTML = text.value;
}