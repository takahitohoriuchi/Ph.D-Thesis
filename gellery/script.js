// 設定
const JSON_PATH = 'videos.json' // ["movies/mp4/a.mp4", ...]
const SCALE = 0.15 // ウォーターフォール時の縮小率（15%）

let msnry = null // Masonry インスタンス共有
let items = [] // 生成した <figure> を保持（切替に使う）

document.addEventListener('DOMContentLoaded', init)

async function init() {
	const grid = document.getElementById('gallery')

	// 1) JSONから動画一覧
	let files = []
	try {
		const res = await fetch(JSON_PATH, { cache: 'no-store' })
		files = await res.json()
	} catch (e) {
		console.error('videos.json 読込失敗:', e)
	}

	// 2) DOM生成（格子モード用の均一サムネ構造）
	items = files
		.filter((p) => p.toLowerCase().endsWith('.mp4'))
		.map((src) => {
			const fig = document.createElement('figure')

			const thumb = document.createElement('div')
			thumb.className = 'thumb'

			const v = document.createElement('video')
			v.autoplay = true
			v.loop = true
			v.muted = true
			v.playsInline = true
			v.preload = 'metadata'
			v.src = src

			thumb.appendChild(v)
			const cap = document.createElement('figcaption')
			cap.textContent = src.split('/').pop()

			fig.appendChild(thumb)
			fig.appendChild(cap)
			grid.appendChild(fig)

			// メタデータが取れたら、後でウォーターフォール用に intrinsic size を保存
			v.addEventListener(
				'loadedmetadata',
				() => {
					fig.dataset.intrinsicW = v.videoWidth || 0
					fig.dataset.intrinsicH = v.videoHeight || 0
				},
				{ once: true }
			)

			return fig
		})

	// 3) 初期表示は「格子」モード
	setUniformMode()

	// 4) トグル操作
	document.getElementById('btn-uniform').addEventListener('click', () => {
		setUniformMode()
		setActive('#btn-uniform')
	})
	document.getElementById('btn-waterfall').addEventListener('click', () => {
		setWaterfallMode()
		setActive('#btn-waterfall')
	})
}

function setActive(sel) {
	document.querySelectorAll('.view-toggle button').forEach((b) => b.classList.remove('active'))
	document.querySelector(sel).classList.add('active')
}

/* ===== モード1：格子 ===== */
function setUniformMode() {
	const grid = document.getElementById('gallery')

	// Masonry がいたら破棄
	if (msnry) {
		msnry.destroy()
		msnry = null
	}

	// クラス切替
	grid.classList.remove('mode-waterfall')
	grid.classList.add('mode-uniform')

	// 格子用に、カード幅はCSSで統一。videoは object-fit:cover（CSS側）
	// ウォーターフォールで付与した inline-style をクリア
	items.forEach((fig) => {
		fig.style.width = '' // Masonry幅クリア
		fig.style.position = '' // 位置リセット（CSSが上書き）
	})
}

/* ===== モード2：ウォーターフォール ===== */
function setWaterfallMode() {
	const grid = document.getElementById('gallery')

	// クラス切替
	grid.classList.remove('mode-uniform')
	grid.classList.add('mode-waterfall')

	// 各動画カードの幅を「元の幅の15%」に設定（高さは自動）
	items.forEach((fig) => {
		const W = Number(fig.dataset.intrinsicW || 0)
		const H = Number(fig.dataset.intrinsicH || 0)

		if (W > 0 && H > 0) {
			// 幅だけ指定すれば、<video> は等比で高さが決まる（CSSで height:auto;）
			const scaledW = Math.max(80, Math.round(W * SCALE)) // あまりに小さすぎるのを防ぐ下限80px
			fig.style.width = scaledW + 'px'
		} else {
			// まだ metadata 未取得なら仮幅
			fig.style.width = '200px'
		}
	})

	// 画像/動画の読み込み完了に合わせてMasonry初期化
	// すでにあれば再レイアウト
	const doLayout = () => {
		if (!msnry) {
			msnry = new Masonry('#gallery', {
				itemSelector: 'figure',
				gutter: 12,
				percentPosition: false,
				// 可変幅アイテムを許容（columnWidth未指定 or 1でもOK）
			})
		} else {
			msnry.layout()
		}
	}

	// 一旦 layout、ロード進行でもレイアウト
	doLayout()
	imagesLoaded('#gallery').on('progress', doLayout)

	// 動画のmetadataが揃ってから最終レイアウト（幅が確定するため）
	document.querySelectorAll('#gallery video').forEach((v) => {
		v.addEventListener('loadedmetadata', doLayout, { once: true })
	})

	// リサイズ時も再レイアウト
	window.addEventListener('resize', () => msnry && msnry.layout(), { passive: true })
}
