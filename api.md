Інтерфейс прикладного программування (API)
Розробникам, програмістам, роботам...

API (Application Programming Interface, або Інтерфейс прикладного програмування) — корисний та сучасний інструмент для розробників при роботі з інформаційними системами. Це набір готових процедур, підпрограм, функцій, посилань чи параметрів, які дозволяють особливим чином використовувати інформаційні системи для отримання структурованих або неструктурованих наборів даних чи іншої взаємодії. Під час розвитку відкритих даних він набув особливої популярності через зручність та оперативність доступу до потрібної інформації шляхом запитів з відповідними параметрами.

Деякі державні та комерційні інформаційні системи мають або використовують API. У тому числі й у систем Верховної Ради України є режим "особливого" доступу (в автоматизованому режимі, напряму або за допомогою цього Порталу) — через API, документація до якого представлена нижче. Якщо ви розробник, то завжди зможете інтегрувати набори даних систем (розділів) Верховної Ради України у власні продукти та рішення. Доступ до API відбувається анонімно без обмежень, але якщо система захисту інфрастуктури раптом заблокує ваш IP, зверніться до адміністратора Порталу для реєстрації IP вашої системи у "білому списку".
Інформаційні системи (розділи) з API:

    Портал відкритих даних ВРУ
    Законодавство України



Інтерфейс прикладного программування (API)
Портал відкритих даних ВРУ

Цей Портал крім звичайного відображення сторінок паспортів наборів та реєстрів (формат HTML) може формувати структуровані набори метаданих кожного паспорту чи набору у трьох відкритих форматах: CSV, JSON та XML. Структури цих наборів описані у відповідному розділі. Для цього потрібно знати внутрішній id (або глобальний guid) ідентифікатор набора даних та додати до її звичайної URL адреси потрібний формат через кому. Наприклад:
Формат 	URL
HTML 	https://data.rada.gov.ua/open/data/id
CSV 	https://data.rada.gov.ua/open/data/id.csv
JSON 	https://data.rada.gov.ua/open/data/id.json
XML 	https://data.rada.gov.ua/open/data/id.xml

Зауваження: API повертає дату та час оновлення файлу чи набору у заголовку HTTP (Last-Modified), тому враховуйте це при програмуванні роботів. Щоб зменшити трафік та навантаження за рахунок перевірки (If-Modified-Since), зберігайте та повертайте її серверу при наступному запиті.

На відміну від статичних метаданих (паспорту чи реєстру набору), які знаходяться у каталозі https://data.rada.gov.ua/ogd/ та оновлюються щогодини, оперативний набір, отриманий через API, додатково містить перелік всіх наявних файлів для перевірки чи завантаження.
Порядок роботи

Зазвичай ідентифікатори не змінюються, а файли з часом оновлюються і можуть, навіть, змінити шлях в результаті реорганізації даних. Тому не варто жорстко запам'ятовувати прямі шляхи до файлів! Перед завантаженням файлу набору спочатку потрібно звернутися за його паспортом й оновити свою копію, перевірити, чи змінилися файли, які завантажували перед тим, а вже потім завантажити сам набір, розмір якого в кілька разів може відрізнятися від метаданих.

Інтерфейс прикладного програмування (API)
Законодавство України

ІПС "Законодавство України" Верховної Ради України в Інтернет/Інтранет, набори якої представлені в окремому реєстрі на Порталі відкритих даних ВРУ, також має API для завантаження й оновлення текстів (та їх редакцій) всіх нормативно-правових документів, які в ній знаходяться.

Для того, щоб скористатися цим API потрібно:

    для підтримки формату запитів json попередньо зареструвати IP-адресу, як користувач REST API, та отримати токен за адресою: https://data.rada.gov.ua/api/token (діє 86400 секунд з 0-00 по 23-59 кожного дня),
    передавати в запитах UserAgent отриманий токен (унікальний рядок типу "231c5dfc-1c60-4d7a-85d0-e47d90fc7f74") для json запитів або OpenData для інших форматів,

    Заголовки HTTP

    GET /laws/show/nreg.json HTTP/1.1
    Host: data.rada.gov.ua
    User-Agent: 231c5dfc-1c60-4d7a-85d0-e47d90fc7f74
    Accept: */*

    Команда curl

    curl -A "OpenData" https://data.rada.gov.ua/laws/show/nreg.txt

    curl -A "231c5dfc-1c60-4d7a-85d0-e47d90fc7f74" https://data.rada.gov.ua/laws/show/nreg.json

    Python

    import requests

    url = "https://data.rada.gov.ua/laws/show/nreg.json"
    headers = {"User-Agent": "231c5dfc-1c60-4d7a-85d0-e47d90fc7f74"}

    response = requests.get(url, headers=headers)

    print("Status Code:", response.status_code)
    print("Response Headers:", response.headers)
    print("Response Body:", response.text)

    PHP

    <?php
    $url = "https://data.rada.gov.ua/laws/show/nreg.json";

    $options = [
        "http" => [
            "method" => "HEAD",
            "header" => "User-Agent: 231c5dfc-1c60-4d7a-85d0-e47d90fc7f74\r\n"
        ]
    ];

    $context = stream_context_create($options);
    $headers = get_headers($url, 1, $context);

    foreach ($headers as $key => $value) {
        echo "$key: $value\n";
    }
    ?>

    без реєстрації (з токеном OpenData) можливий доступ до JSON картки та списків документів, текстів у форматі TXT,
    врахувати наступні ліміти:
        кількість запитів на хвилину - до 60, але бажано між запитами робити рандомну паузу від 5 до 7 секунд.
        кількість запитів на день - до 100000
        кількість байтів на день - до 200Mb
        кількість сторінок* на день - до 800000 (*сторінкою вважається частина документу приблизно 40-50kb)
    ліміти також можна перевірити через api з токеном: https://data.rada.gov.ua/api/limits
    звертатись за токеном або перевіряти ліміти перед кожним запитом - ЗАБОРОНЕНО! (такі айпі будуть блокуватись)
    формувати посилання на документи та переліки наступного вигляду:

Документ або список 	Формат 	URL
Документи
Текст документа nreg 	HTML 	https://data.rada.gov.ua/laws/show/nreg
Картка документа nreg 	HTML 	https://data.rada.gov.ua/laws/card/nreg
Документ повністю nreg 	JSON 	https://data.rada.gov.ua/laws/show/nreg.json
Картка документа nreg 	JSON 	https://data.rada.gov.ua/laws/card/nreg.json
Чистий текст документа nreg 	TXT 	https://data.rada.gov.ua/laws/show/nreg.txt
Списки документів
Список поновлених документів 	HTML 	https://data.rada.gov.ua/laws/main/r
Список найновіших надходжень (за день) 	HTML 	https://data.rada.gov.ua/laws/main/nn
Список нових надходжень (30 днів) 	HTML 	https://data.rada.gov.ua/laws/main/n
Список всіх документів (по сторінках) 	HTML 	https://data.rada.gov.ua/laws/main/a[/page1]
Список nreg номерів поновлених документів 	TXT 	https://data.rada.gov.ua/laws/main/r.txt
Список dokid номерів поновлених документів 	JSON 	https://data.rada.gov.ua/laws/main/r/docs.json
Список поновлених документів з реквізитами по сторінкам 	JSON 	https://data.rada.gov.ua/laws/main/r[/page1].json
Список RSS поновлених документів 	XML 	https://data.rada.gov.ua/laws/main/r.xml
Список карток та посилань на документи, розділених табуляціями 	TSV 	https://data.rada.gov.ua/laws/main/r.tsv

Зауваження: API повертає дату та час оновлення документа чи списка у заголовку HTTP (Last-Modified), тому враховуйте це при програмуванні роботів. Щоб зменшити трафік та навантаження за рахунок перевірки (If-Modified-Since), зберігайте та повертайте її серверу при наступному запиті.
Структури даних

Опис структур даних щодо документа знаходится у наборах карткок (основних реквізитів) та історії (класифікація, посилання) документів на Порталі. Значення за ідентифікаторами полів знаходяться у відповідних наборах довідників.
Група
section 	Елемент
element 	Формат
format 	Параметри
attributes 	Призначення
annotation
docs 	doc 	object[\t] 	@doc_card=(dokid nreg nazva status types organs minjust npix) 	Картка документа
doc 	dokid 	integer 	index=true 	Ідентифікатор документа
doc 	nreg 	string 	pattern=^[0-9nprvz][0-9\/\_\-a-zа-яїіёєґ]{3,11}$ 	Системний номер документа
doc 	nazva 	string 		Назва документа
doc 	status 	object[:], short 	default=0, reference=#stan, @stat_card=(status status_from status_to) 	Стан документа
doc 	types 	array[|], integer 	notnull, unique, reference=#typs 	Види документа
doc 	organs 	object[:] 	@org_card=(orgid orgdat orgnum) 	Видавники документа
doc 	minjust 	object[:] 	@min_card=(minid mindat minnum) 	Реєстрація документа
doc 	npix 	byte 	default=0 	Номер картинки для відображення у списку
doc 	datred 	date 	pattern=^(\d{4})(\d\d)(\d\d)$ 	Дата поточної редакції
docs 	ist 	object[\t] 	@ist_card=(dokid history links publics temy klasy tags komitet bookmark) 	Історія документа, публікації, класифікація, зв'язки
ist 	history 	array[|], object[:] 	@hist_card=(poddat podid pidstava) 	Історія документа
ist 	links 	object[#] 	@link_card=(pos_links pr_links zv_links text_links) 	Відношення документа
ist 	publics 	array[|], object[:] 	@pubs_card=(pubdat vydid n_pub) 	Публікації документа
ist 	temy 	array[|], integer 	reference=#temy 	Теми документа
ist 	klasy 	array[|], integer 	reference=#klasname 	Класифікація документа
ist 	tags 	array[|], integer 	reference=#tags 	Ознаки документа
ist 	komitet 	array[|], integer 	reference=#koms 	Комітети документа
ist 	bookmark 	object[#] 	reference=#book, @book_card=(book_pos book_cnt) 	Інформація про закладки в тексті
docs 	stru 	object[\t] 	@stru_card=(id tree_id pos len page parent level line stru subtree style text typ typn show) 	Структура документа, текст, дерево, типи елементів
stru 	id 	string 	pattern=^[on](\d+)$ 	Ідентифікатор структури
stru 	tree_id 	string 	pattern=^((zg|ty|kn|rz|gl|st|nz|pr|fr|ch|pu|pp|cm)[^\:]*)(\:\1)*$ 	Ідентифікатор струтурного елемента у дереві
stru 	pos 	integer 		Позиція в тексті
stru 	len 	integer 		Розмір в символах
stru 	page 	integer 		Номер сторінки, якщо документ поділяється на сторінки
stru 	parent 	string 		Ідентифікатор "батьківського" елементу
stru 	level 	integer 		Рівень структури в дереві
stru 	line 	string 		Рядок для відображення скороченої структури
stru 	stru 	string 		Номер статті/пункту/підпункту структури
stru 	subtree 	string 		Список ідентифікаторів номерів підструктури (через кому)
stru 	style 	integer 		Номер стилю
stru 	text 	string 		Оригінал тексту абзацу в форматі HTML
stru 	typ 	string 	pattern=^(TY| NZ|FR|KN|RZ|PR| GL|ST|CH|PU|PP| CM|TB|IM)$ 	Ідентифікатор типу (2 символи)
stru 	typn 	string 	pattern=^(ALL| TXT|IMG|TAB| IDB|TWH|TWR|ROW| SPE|COM|SIG)$ 	Ідентифікатор типу (3 символи)
stru 	show 	string 		Тип для показу (typ)
stru 	nums 	array[,] 		Список ідентифікаторів структури для послідовної сборки тексту