module token::TKN {
    use sui::coin::{Self, TreasuryCap, CoinMetadata};
    use sui::url;

    const RECIPIENT: address = @0x_YOUR_ADDRESS_HERE;
    const SYMBOL: vector<u8> = b"TKN";
    const NAME: vector<u8> = b"Token";
    const DESCRIPTION: vector<u8> = b"Test Token";
    const IMAGE_DATA: vector<u8> = b"...";
    const DECIMALS: u8 = 9;
    const SUPPLY: u64 = 1_000_000_000_000_000;

    public struct TKN has drop {}

    fun init(
        witness: TKN,
        ctx: &mut TxContext
    ) {
        let (treasury, metadata) = mint(witness, ctx);
        revoke(treasury, metadata);
    }

    fun mint(
        witness: TKN,
        ctx: &mut TxContext
    ): (TreasuryCap<TKN>, CoinMetadata<TKN>) {
        let (mut treasury, metadata) = coin::create_currency(
            witness,
            DECIMALS,
            SYMBOL,
            NAME,
            DESCRIPTION,
            option::some(url::new_unsafe_from_bytes(IMAGE_DATA)),
            ctx
        );
        coin::mint_and_transfer<TKN>(
            &mut treasury,
            SUPPLY,
            RECIPIENT,
            ctx
        );
        (treasury, metadata)
    }

    fun revoke(
        treasury: TreasuryCap<TKN>,
        metadata: CoinMetadata<TKN>,
    ) {
        transfer::public_freeze_object(metadata);
        transfer::public_freeze_object(treasury);
    }
}
