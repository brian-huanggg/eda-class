# 需在 IIC-OSIC-TOOLS 容器內執行
export PDK ?= sky130A

all: flow

flow: config.json src/counter.v
	librelane config.json --pdk $(PDK)

# 用 KLayout 開啟最新一次 run 的 GDS
view:
	klayout runs/$$(ls -t runs | head -1)/final/gds/counter.gds

clean:
	rm -rf runs
