module journal::journal;

use std::string::String;
use std::vector;
use sui::clock::Clock;
use sui::object; // for object::new
use sui::object::UID; // UID type
use sui::tx_context::TxContext;

/// A journal entry stored within a `Journal` object.
public struct Entry has store {
    content: String,
    create_at_ms: u64,
}

/// An owned Sui object representing a journal.
public struct Journal has key, store {
    id: UID,
    owner: address,
    title: String,
    entries: vector<Entry>,
}

/// Creates and returns a new `Journal` object with an empty entries vector.
public fun new_journal(title: String, ctx: &mut TxContext): Journal {
    Journal {
        id: object::new(ctx),
        owner: ctx.sender(),
        title,
        entries: vector::empty<Entry>(),
    }
}

/// Adds a new entry to the journal after verifying ownership.
public fun add_entry(journal: &mut Journal, content: String, clock: &Clock, ctx: &TxContext) {
    // Ensure only the owner can add entries
    assert!(journal.owner == ctx.sender(), 0);

    let entry = Entry { content, create_at_ms: clock.timestamp_ms() };
    vector::push_back(&mut journal.entries, entry);
}